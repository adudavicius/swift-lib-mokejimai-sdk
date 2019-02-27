import ObjectMapper

public enum URLRequestHeader {
 
    case jwtToken(String)
    case acceptLanguage(String)
    case other(headerKey: String, value: String)

    var headerKey: String {
        switch self {
        case .jwtToken(_):
            return "Authorization"
        case .acceptLanguage(_):
            return "Accept-Language"
        case .other(let key, _):
            return key
        }
    }
    
    var value: String {
        switch self {
        case .jwtToken(let token):
            return "Bearer " + token
        case .acceptLanguage(let locale):
            return locale
        case .other(_, let val):
            return val
        }
    }
}


public class MokejimaiRequestHeaders {
    
    var headers: [URLRequestHeader]
    
    public init(headers: [URLRequestHeader]) {
        self.headers = headers
    }
    
    public func updateHeader(_ header: URLRequestHeader) {
        headers.removeAll(where: { $0.headerKey == header.headerKey })
        headers.append(header)
    }
}
