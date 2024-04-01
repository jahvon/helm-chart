package mealie2bring

import (
	"fmt"
	"os"
)

const (
	mealieTokenKey = "MEALIE_TOKEN"
	mealieURLKey   = "MEALIE_URL"
)

func main() {
	mealieToken := os.Getenv(mealieTokenKey)
	mealieURL := os.Getenv(mealieURLKey)
	if mealieToken == "" || mealieURL == "" {
		fmt.Println("MEALIE_TOKEN or MEALIE_URL environment variable not set")
		os.Exit(1)
	}

}
