# BusinessDisplay

This repository contains the source code for a single-screen mobile application developed using SwiftUI for iOS. The application fetches a business's hours of operation from a specified endpoint and displays them to the user. 

## Demo
### Video
https://github.com/sunnyleeyun/BusinessDisplay/assets/20850892/5ed58ccc-105c-401d-983b-2877612a117f

### Screenshots
![Simulator-Screenshot-iPhone-15-2](https://github.com/sunnyleeyun/BusinessDisplay/assets/20850892/53a75819-f547-4719-a7b2-995cb3fbce7d)

### Requirements
The application fulfills the following requirements:
- Hits the provided endpoint to retrieve a business's hours of operation.
- Displays the hours of operation to the user as specified, including support for late-night time and "open 24h" time.
- Matches the provided Figma design.

## High Level Architecture
<img width="1135" alt="Screenshot 2024-01-13 at 5 43 31 PM" src="https://github.com/sunnyleeyun/BusinessDisplay/assets/20850892/0539f1af-8094-42a4-9063-9ef0d7639e81">

- **MVVM (Model-View-ViewModel)**: Adopted the MVVM architectural pattern for clear separation of concerns and maintainability. The model represents the data and business logic, the view handles the UI, and the view model acts as an intermediary between the model and view, facilitating seamless communication.
- **Network Manager with Location Fetching Protocol**: Implemented a custom network manager to handle data fetching. Utilized a Location Fetching Protocol to define a standardized approach for retrieving location-related information. This modular design ensures flexibility and ease of integration for future expansions or modifications.


## Development Process
1. **Test Driven Development**: Given the intricacies of managing various time-related scenarios in the app, such as bold formatting during specific time slots and highlighting when a restaurant is closing within an hour, I opted for a Test-Driven Development (TDD) approach. This involves creating all test cases before commencing development. As depicted in the code coverage report, I meticulously crafted **19 test cases**, resulting in an impressive **91% code coverage**.
2. **GitHub Flow Adoption**: In the context of version control and branching strategies, I deliberated between Gitflow and GitHub Flow. Opting for GitHub Flow, I found its simplicity ideal for a solo developer, especially in the pre-version 1 launch phase. GitHub Flow's straightforward approach, which involves branches primarily for features and pull requests for merging, appealed to me. I plan to consider Gitflow after establishing a stable version and acquiring users, as it introduces additional branches like hotfixes. Notably, employing branches for each feature and utilizing pull requests ensures transparency and traceability throughout the development process.

## Design Decisions
1. **In-House Network Manager Development**: The choice was made to construct a straightforward and refined network manager internally, rather than opting for third-party solutions such as Alamofire. Given the app's simplicity, the decision was rooted in the desire to avoid unnecessary complexities. By crafting a custom network manager, the intention was to keep the app lightweight and easily manageable.
2. **Combination of Async-await and completion handler**: Chose to integrate both Async-Await and Completion Handler to showcase proficiency with contemporary and traditional asynchronous programming paradigms. The adoption of async-await reflects modern Swift capabilities, whereas the inclusion of completion handlers accommodates legacy code structures commonly found in older applications. This approach demonstrates versatility in handling asynchronous operations across different codebases.

## Additional Flair
1. **Loading Screen**: Implemented a visually appealing loading screen to enhance the user experience during data retrieval.
2. **Error Screen**: Designed a user-friendly error screen that provides informative feedback in case of unexpected issues.
3. **Animations**: Introduces dynamic animations to elevate the main view's interactivity. When expanding the card, animations smoothly reveal additional content. Simultaneously, the disclosure arrow rotates 90 degrees to the right, accompanied by a gradual hiding of the "View Menu" section. Similarly, collapsing the card triggers reverse animations, ensuring a seamless and engaging transition.
4. **Comprehensive Unit Tests**: Conducted thorough unit testing encompassing various combinations of durations and times to ensure robust test coverage and validate the application's functionality under different scenarios.


## Project Management
<img width="1158" alt="Screenshot 2024-01-13 at 6 17 00 PM" src="https://github.com/sunnyleeyun/BusinessDisplay/assets/20850892/1275d182-1750-453f-a821-11bc6d609357">

## Code Coverage
<img width="1166" alt="Screenshot 2024-01-13 at 5 41 04 PM" src="https://github.com/sunnyleeyun/BusinessDisplay/assets/20850892/b0a844c8-4aec-4cc0-a9f2-ba7189b37e12">




