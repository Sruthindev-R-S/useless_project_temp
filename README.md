<img width="1280" height="640" alt="git (1)" src="https://github.com/user-attachments/assets/8920b256-2ba8-4988-b824-5351134eb4bd" />



# Switches 🎯


## Basic Details
### Team Name: null.exe


### Team Members
- Team Lead: Rhithujith P - School of engineering,CUSAT
- Member 2: Sruthindev R S -School of engineering,CUSAT


### Project Description
Mobile App which count the number of Switches which have been turned on and will give memes according to it

### The Problem (that doesn't exist)
Blind Mobile users who can't see switchboard but can take pictures of it

### The Solution (that nobody asked for)
Mobile App for counting switches

## Technical Details
### Technologies/Components Used
For Software:
- Python,Dart
- Fastapi
- Numpy
- Docker

For Hardware:


### Implementation
For Software:

```mermaid
flowchart TB
	Start([User opens the mobile app]) --> Capture[User captures a clear image of the switchboard]
	Capture --> Preview[Mobile app shows the captured image preview]
	Preview --> Valid{Is the image clear and valid?}
	Valid -- No --> Retake[Ask the user to retake the image]
	Retake --> Capture
	Valid -- Yes --> Prepare[Compress image and prepare API request]

	subgraph Mobile[Mobile Application]
		Capture
		Preview
		Valid
		Retake
		Prepare
		Result[Receive switch count from server]
		Meme[Select an appropriate meme for the switch count]
		Display[Display switch count and selected meme]
	end

	Prepare --> Upload[Send image to the render server]

	subgraph Server[Render Server]
		Receive[Receive image request]
		Check[Validate file format and request data]
		Preprocess[Resize, normalize, and preprocess image]
		Inference[Run the YOLO object-detection model]
		Filter[Filter low-confidence detections]
		Count[Count detected switches]
		Response[Build JSON response with switch count]
	end

	Upload --> Receive
	Receive --> Check
	Check --> Preprocess
	Preprocess --> Inference
	Inference --> Filter
	Filter --> Count
	Count --> Response
	Response --> Result
	Result --> Meme
	Meme --> Display
	Display --> Finish([User views the result])

	classDef user fill:#fff4cc,stroke:#c48a00,stroke-width:2px,color:#222;
	classDef mobile fill:#dff3ff,stroke:#1677a8,stroke-width:2px,color:#222;
	classDef server fill:#e5f7e5,stroke:#2d8a4e,stroke-width:2px,color:#222;
	class Start,Finish user;
	class Capture,Preview,Valid,Retake,Prepare,Result,Meme,Display mobile;
	class Receive,Check,Preprocess,Inference,Filter,Count,Response server;
```

# Installation
Front end:
```bash
cd frontend
flutter pub get
```

# Run
For debugging:
```bash
flutter run
```

To build the release APK:
```bash
flutter build apk --release
```
Backend:
The backend is hosted on Render, so it does not need to be run locally for normal use. To test the backend locally:
```bash
cd backend
pip install -r requirements.txt
uvicorn app:app --reload
```


### Project Documentation
For Software:
- **Flutter:** Used to build the cross-platform mobile application with a simple and responsive user interface.
- **Python and FastAPI:** Python is easy to use for machine-learning integration, while FastAPI provides a fast and lightweight backend API for processing images and returning switch counts.

# Screenshots (Add at least 3)
![Home screen](assets/HOME.jpeg)
*Home screen where the user starts the switch-counting process.*

![Loading screen](assets/LOADING.jpeg)
*Loading screen shown while the image is being processed by the backend.*

![Final result screen](assets/fINAL.jpeg)
*Final screen displaying the detected switch count and the selected meme.*

# Diagrams


For Hardware:

# Schematic & Circuit


### Project Demo
# Video
https://drive.google.com/file/d/1RToK2Jdfi2-equ5t8oTajCpKdgiCFOWq/view?usp=drive_link



## Team Contributions


---
Made with ❤️ at TinkerHub Useless Projects 

![Static Badge](https://img.shields.io/badge/TinkerHub-24?color=%23000000&link=https%3A%2F%2Fwww.tinkerhub.org%2F)
![Static Badge](https://img.shields.io/badge/UselessProjects--26-26?link=https%3A%2F%2Ftinkerhub.org%2Fevents%2F1M8ORET9A1%2Fuseless-projects-3.0)



