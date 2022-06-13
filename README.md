# ChessTimeX


## SwiftUI + Combine + MVVM chess clock
It supports Classic and Hourglass game modes and for increment type it only supports fisher (or none) for now


## Working principle:
The main view is View->GameView->GameView.swift which includes two timer views (View->TimerView->TimerView.swift) TimerView uses a timer viewModel object (View->TimerView-TimerViewModel.swift) which includes playerShowTime (the time player has left), isTimerActive (whether the TimerView should be in active or inactive state) and numberOfMoves (the total number of moves the player has taken) which this TimerViewModel is provided by GameViewModel (View->GameView->GameViewModel.swift), GameViewModel manages the interactions between GameView and GameProtocol based structs, there is currently two game types each with it's own struct and both following GameProtocol (Utils->Protocols->GameProtocol.swift).
Each GameProtocol instance uses GameTimerProtocol (Utils->Protocols->GameTimerProtocol.swift) based structs to manage each players remaining time and passes the seconds value subjects to the viewModel side using two computed variables (firstPlayerSeconds, secondPlayerSeconds) when the time ticks GameViewModel would receive a value in it's subscription to playerSeconds values which in turn would update the TimeViewModel to update each playerShowTime accordingly.
GameProtocol also exposes methods for: play, pause, reset, changeToFirstPlayer, changeToSecondPlayer and values for player active state and number of moves


## Style Guidelines:
Other than following solid principles and basis of mvvm the codebase uses few guidelines to makesure the code is easily readable and usable: 
1) the names used for each variable and method does exactly what it says it does and there is no short named or unrelated names which makes it easier to understand the functionality. ex:
```swift
    func changeToFirstPlayer() {
        if !firstPlayerTimer.isRunning.value && secondPlayerTimer.timeSeconds.value > 0 {
            // Stop second player's timer and start the first player's
            // Also invoke changingFromSecondToFirst method so game types
            //   could implement custom functionality on user state change
            secondPlayerTimer.stopTimer()
            changingFromSecondToFirst()
            firstPlayerTimer.startTimer()
            // Send the updated value to isFirstPlayersTurn to update isActive states
            self.isFirstPlayersTurn.send(true)
            // Increment previously active player's moves
            self.secondPlayerMoves.send(self.secondPlayerMoves.value + 1)
        }
    }
```
which changes the game active state (from second player) to first player

2) similar functionality or variables inside a file are bunched up together, for example inside GameProtocol each value relating to firstPlayer is bunched up together and secondPlayer next, then we have the functional methods which the GameViewModel would use. ex:
```swift
    // MARK: First player states and values
    var firstPlayerSeconds: CurrentValueSubject<Int, Never> {
        return firstPlayerTimer.timeSeconds
    }
    
    var firstPlayerNoOfMoves: CurrentValueSubject<Int, Never> {
        return firstPlayerMoves
    }
    
    var firstTimerActive: AnyPublisher<Bool, Never> {
        // Combining two value subjects into a single publisher so if
        //   any of them changes there would be value published to the
        //   firstTimerActive publisher
        Publishers.CombineLatest(isPlaying, isFirstPlayersTurn)
            .map { $0.0 && $0.1 }
            .eraseToAnyPublisher()
    }
```

3) at any point where the code might get complex or further explanation is required there are comments to hint at the functionality


## The UI/UX
As I am not a designer or anything the UI for sure needs a lot of improvements but I tried my best to keep the UX simple and intuitive so users could get the functionality they need fast and easy


## Future Changes
- Currently because of the lack of time I did not implement a database connection which means there is no permenant storage for the custom game rules but if I would have time in future I will implement that and publish it to github
- FIDE game type is very useful and popular but a bit more time consuming to implement so in future that would a great implementation
