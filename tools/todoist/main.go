package main

import (
	"flag"
	"fmt"
	"os"
	"strings"

	"github.com/volyanyk/todoist"
)

const (
	InboxProjectName       = "Inbox"
	GeneralProjectName     = "General tasks"
	DevelopmentProjectName = "Software engineering"
	WorkProjectName        = "CarGurus"
	HomeProjectName        = "Home improvement projects"
)

const (
	normalPriority = iota
	lowPriority
	midPriority
	highPriority
)

func main() {
	newCommand := flag.NewFlagSet("new", flag.ExitOnError)
	newContent := newCommand.String("content", "", "Task content string")
	newDescription := newCommand.String("desc", "", "Task description string")

	viewCommand := flag.NewFlagSet("view", flag.ExitOnError)
	viewID := viewCommand.String("id", "", "ID")

	apiToken, ok := os.LookupEnv("TODOIST_API_TOKEN")
	if !ok {
		fmt.Println("TODOIST_API_TOKEN environment variable not set")
		os.Exit(1)
	}
	client := todoist.New(apiToken)
	if stale, err := staleCache(); stale {
		if err := refreshCache(client); err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		if os.Args[1] == "refresh" {
			fmt.Println("Successfully refreshed project and label cache!")
			return
		}
	} else if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	if len(os.Args) < 2 {
		fmt.Println("expected 'new' or 'view' subcommands")
		os.Exit(1)
	}

	switch os.Args[1] {
	case "refresh":
		if err := refreshCache(client); err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	case "new":
		if err := newCommand.Parse(os.Args[2:]); err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		projectId, labels, content, priority := parseContentParts(*newContent)
		fmt.Printf("Creating new task %s\n", content)
		task, err := client.AddTask(todoist.AddTaskRequest{
			Content:     content,
			ProjectId:   projectId,
			Labels:      labels,
			Description: *newDescription,
			Priority:    priority,
		})
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		fmt.Printf("Success!\n%s", task.Url)
	case "view":
		err := viewCommand.Parse(os.Args[2:])
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		fmt.Printf("Viewing project with id: %s\n", *viewID)
	default:
		flag.PrintDefaults()
		os.Exit(1)
	}
}

func parseContentParts(content string) (
	projectId string,
	labels []string,
	finalContent string,
	priority int,
) {
	parts := strings.Split(content, " ")
	if len(parts) < 2 {
		return "", nil, content, normalPriority
	}

	for i, part := range parts {
		if projectId == "" {
			projectId = parseProjeectId(part)
			if projectId != "" {
				parts = append(parts[:i], parts[i+1:]...)
				continue
			}
		}
		if labels == nil {
			labels = parseLabels(part)
			if len(labels) > 0 {
				parts = append(parts[:i], parts[i+1:]...)
				continue
			}
		}
		if priority == normalPriority {
			priority = parsePriority(part)
			if priority != normalPriority {
				parts = append(parts[:i], parts[i+1:]...)
				continue
			}
		}
	}
	finalContent = strings.Join(parts, " ")
	return
}

func parseProjeectId(block string) string {
	if strings.HasPrefix(block, "@") {
		projects, err := getProjectsFromCache()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		for _, project := range projects {
			switch strings.ToLower(block[1:]) {
			case "cg", "cargurus", "work":
				if strings.ToLower(project.Name) == strings.ToLower(WorkProjectName) {
					return project.ID
				}
			case "home":
				if strings.ToLower(project.Name) == strings.ToLower(HomeProjectName) {
					return project.ID
				}
			case "general", "reviewed", "skip":
				if strings.ToLower(project.Name) == strings.ToLower(GeneralProjectName) {
					return project.ID
				}
			case "dev", "development", "eng":
				if strings.ToLower(project.Name) == strings.ToLower(DevelopmentProjectName) {
					return project.ID
				}
			case "inbox", "in":
				if strings.ToLower(project.Name) == strings.ToLower(InboxProjectName) {
					return project.ID
				}
			default:
				if strings.ToLower(project.Name) == strings.ToLower(block[1:]) {
					return project.ID
				}
			}
		}
	}
	return ""
}

func parseLabels(block string) []string {
	var labels []string
	if strings.HasPrefix(block, "[") && strings.HasSuffix(block, "]") {
		labelsStr := block[1 : len(block)-1]
		labelsSplit := strings.Split(labelsStr, ",")
		parsedLabels, err := getLabelsFromCache()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		for _, inputLabel := range labelsSplit {
			for _, label := range parsedLabels {
				if strings.ToLower(label.Name) == strings.ToLower(inputLabel) {
					labels = append(labels, label.Name)
					break
				}
			}
		}
	}
	return labels
}

func parsePriority(block string) int {
	if strings.HasPrefix(block, "!") {
		switch strings.ToLower(block[1:]) {
		case "high":
			return highPriority
		case "mid":
			return midPriority
		case "low":
			return lowPriority
		}
	}
	return normalPriority

}
