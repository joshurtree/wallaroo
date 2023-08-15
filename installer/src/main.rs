#[allow(unused_imports)]

use prompts::{autocomplete::AutocompletePrompt, select::SelectPrompt, confirm::ConfirmPrompt, Prompt};
use std::process::{Command, Stdio};
use std::println;
use std::string::String;

async fn select_with_default(prompt: String, choices: Vec<String>, err_msg: String) -> String {
    match SelectPrompt::new(prompt, choices.clone())
        .run()
        .await {
            Ok(Some(s)) => s,
            Ok(None) => choices.first().expect("selected choice").to_string(),
            Err(_e) => panic!("{}", err_msg)
        }
}

fn main() {
    println!("Starting installl...");
    let disks_raw = Command::new("fdisk")
        .arg("-l")
        .stdout(Stdio::piped())
        .spawn()
        .expect("List of disks")
        .stdout
        .expect("List of disks");  

    let disks = Command::new("grep")
        .arg("^Disk")
        .stdin(Stdio::from(disks_raw))
        .output()
        .expect("Listing disks failed: grep issue")
        .stdout;

    let processed_disks = String::from_utf8(disks)
        .expect("Listing disks failed")
        .split('\n')
        .map(|disk| disk.to_string())
        .collect::<Vec<String>>();

    async {
        let install_disk = select_with_default(
                            String::from("Select a disk"), 
                            processed_disks, 
                            String::from("OOOOKKKKAAAAYYY")
                        );
        println!("{}", install_disk.await.to_string());
    };
}

