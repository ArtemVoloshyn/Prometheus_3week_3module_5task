/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

// TeleToken bot
var TeleToken = os.Getenv("TELE_TOKEN")



// kbotCmd represents the kbot command
var kbotCmd = &cobra.Command{
	Use:   "kbot",
	Aliases: []string {"start"},
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("kbot %s started", appVersion)
		//This line creates a new Telegram bot instance using the telebot.NewBot function.
		//The TeleToken variable is expected to contain the Telegram API token for your bot, and is used as a parameter to the function.
		//The Settings struct is used to configure the bot's behavior.
		//In this case, the URL field is set to an empty string, indicating that the default Telegram API URL should be used. The Token field is set to the value of the TeleToken variable, indicating the API token for the bot. Finally, the Poller field is set to a telebot.
		//LongPoller instance with a timeout of 10 seconds, indicating that the bot should poll for new messages every 10 seconds.
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
		//This line checks if there was an error when creating the bot.
		// If there was, it prints an error message to the console indicating that the TELE_TOKEN environment variable should be checked.
		//It then exits the program using the return statement.
		//Overall, this code creates a new Telegram bot instance, sets some basic configuration settings, and checks for any errors during the process.
		//If everything goes smoothly, the bot is ready to receive and respond to messages.

		if err != nil {
			log.Fatalf("Please check TELE_TOKEN ENV VARIABLE. %S", err)
			return
		}

		//This line of code is setting up a handler function for when a text message is received by the kbot bot instance.
		//The function passed as an argument is an anonymous function that takes a telebot.Context parameter and returns an error (or nil if no error occurs)
		kbot.Handle(telebot.OnText, func(m telebot.Context) error {

			log.Print(m.Message().Payload, m.Text())
			return err
		})

		//kbot.Handle(telebot.On("/hello", func(c tele.Context) error {
		//	return c.Send("Hello!")

		kbot.Start()

	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// kbotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// kbotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
