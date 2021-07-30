//
//  UserService.swift
//  JsonPlaceHolderUsers
//
//  Created by Firat Tamur on 7/30/21.
//

import Moya

enum UserService {
    
    case createUser(name: String)
    case readUsers
    case updateUser(id: Int, name: String)
    case deleteUser(id: Int)
    
}

extension UserService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        
        switch self {
    
            case .createUser(name: _):
                return "/users"
            case .readUsers:
                return "/users"
            case .updateUser(id: let id, name: _):
                return "/users/\(id)"
            case .deleteUser(id: let id):
                return "/users/\(id)"
            
        }
        
    }
    
    var method: Method {
        
        switch self {
        
            case .createUser(name: _):
                return .post
            case .readUsers:
                return .get
            case .updateUser(id: _, name: _):
                return .put
            case .deleteUser(id: _):
                return .delete
                
        }
        
        
    }
    
    var sampleData: Data {
        
        switch self {
        
            case .createUser(name: let name):
                return "{'name':'\(name)'}".data(using: .utf8)!
            case .readUsers:
                return Data()
            case .updateUser(id: let id, name: let name):
                return "{'id':'\(id)', 'name':'\(name)'}".data(using: .utf8)!
            case .deleteUser(id: let id):
                return "{'id':'\(id)'}".data(using: .utf8)!
            
        }
        
    }
    
    var task: Task {
        
        switch self {
        
            case .createUser(name: let name):
                return .requestParameters(parameters: ["name": name],
                                          encoding: JSONEncoding.default)
            case .readUsers:
                return .requestPlain
            case .updateUser(id: _, name: let name):
                return .requestParameters(parameters: ["name": name],
                                          encoding: JSONEncoding.default)
            case .deleteUser(id: _):
                return .requestPlain
            
        }
        
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

}

