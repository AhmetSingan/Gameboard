import UIKit

public enum MoveError: ErrorType {
    
    /// Piece cannot move to that square
    case InvalidMove
    /// Cannot take out your own piece
    case FriendlyFire
    /// Another piece is in the way
    case BlockedMove
    /// Piece is not of the current player
    case NotYourTurn
    /// Ummm... I think you may be lost
    case NoPlayer
    /// What type of game are you playing???
    case IncorrectPieces
    /// Validation is unfinished... go ahead and cheat.
    case ValidationFailed
    
}

extension GameBoard {
    
    func validateNotFriendlyFire(p1: Piece, _ p2: Piece) throws -> Bool {
        
        var _player1: Int?
        var _player2: Int?
        
        for (p,pieces) in playerPieces.enumerate() {
            
            if pieces.containsString(p1) { _player1 = p }
            if pieces.containsString(p2) { _player2 = p }
            
        }
        
        guard let player1 = _player1 else { throw MoveError.NoPlayer }
        
        if let player2 = _player2 {
            
            guard player1 != player2 else { throw MoveError.FriendlyFire }
            
        }
        
        return true
        
    }
    
    func validatePlayer(piece: Piece) -> Bool {
        
        return player1Turn ? playerPieces[0].containsString(piece) : playerPieces[1].containsString(piece)
        
    }
    
    func validateMove(s1: Square, _ s2: Square) throws {
        
        guard let p1 = grid[s1.0][s1.1] as? Piece else { throw MoveError.IncorrectPieces }
        guard let p2 = grid[s2.0][s2.1] as? Piece else { throw MoveError.IncorrectPieces }
        
        guard validatePlayer(p1) else { throw MoveError.NotYourTurn }
        try validateNotFriendlyFire(p1, p2)
        
        switch _type {
            
        case .Chess: try Chess.validateMove(s1, s2, p1, p2)
        case .Checkers: try Checkers.validateMove(s1, s2, p1, p2)
            
        }
        
    }
    
}
