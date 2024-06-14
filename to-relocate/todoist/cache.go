package main

import (
	"encoding/json"
	"os"
	"time"

	"github.com/volyanyk/todoist"
)

const (
	cacheTimestampFile   = "last_cache_timestamp"
	cacheTimestampFormat = "2006-01-02T15:04:05Z"

	projectsCacheFile = "projects_cache.json"
	labelsCacheFile   = "labels_cache.json"
)

func refreshCache(client *todoist.Client) error {
	projects, err := client.GetProjects()
	if err != nil {
		return err
	}
	err = writeJSON(projectsCacheFile, projects)
	if err != nil {
		return err
	}
	labels, err := client.GetLabels()
	if err != nil {
		return err
	}
	err = writeJSON(labelsCacheFile, labels)
	if err != nil {
		return err
	}

	tsFile, err := os.Create(cacheTimestampFile)
	if err != nil {
		return err
	}
	defer tsFile.Close()
	_, err = tsFile.WriteString(time.Now().Format(cacheTimestampFormat))
	return err
}

func staleCache() (bool, error) {
	tsFile, err := os.Open(cacheTimestampFile)
	if err != nil {
		return true, nil
	}
	defer tsFile.Close()
	var ts string
	_, err = tsFile.Read([]byte(ts))
	if err != nil {
		return true, nil
	}
	timestamp, err := time.Parse(cacheTimestampFormat, ts)
	if err != nil {
		return true, nil
	}
	return time.Since(timestamp) > 24*time.Hour, nil
}

func getProjectsFromCache() ([]todoist.Project, error) {
	projects := make([]todoist.Project, 0)
	err := readJSON(projectsCacheFile, &projects)
	return projects, err
}

func getLabelsFromCache() ([]todoist.Label, error) {
	labels := make([]todoist.Label, 0)
	err := readJSON(labelsCacheFile, &labels)
	return labels, err
}

func writeJSON(filename string, data interface{}) error {
	file, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer file.Close()
	encoder := json.NewEncoder(file)
	encoder.SetIndent("", "  ")
	return encoder.Encode(data)
}

func readJSON(filename string, data interface{}) error {
	file, err := os.Open(filename)
	if err != nil {
		return err
	}
	defer file.Close()
	decoder := json.NewDecoder(file)
	return decoder.Decode(data)
}
