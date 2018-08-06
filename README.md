# Visalto

![alt Visalto](Visalto/logo.png)

Visalto is a lightweight framework for asynchronous image loading from the web or disk. 
It uses in-memory and disk caching.
Basic image loading looks as follows:

```
let url = URL(string: “example.com/test.jpg”)!

Visalto.shared.loadImage(with: url, completionQueue: .main) { result in

    switch result {
    case .failure(let error):
        print(error.localizedDescription)

    case .success(let image):
        // requested image is here
        break
    }	

}
```
The same interface is used for loading an image from the disk and from the web.

For cancelation of operation just call `cancelLoading` with the url which was used while operation creation

```
Visalto.shared.cancelLoading(for: url)
```

## Possible customizations

There are a lot of parameters available for customization of image loading behaviour.

You can set your own URL session which will be used for remote image downloading.
```
let myCustomURLSession: URLSession = ...
Visalto.shared.setURLSession(myCustomURLSession))
```

Set maximum concurrent loading operations 

```
Visalto.shared.maxConcurrentLoadingsCount = 10
```

Set quality of service of image loading queue
```
Visalto.shared.qualityOfService = .userInteractive
```

Turn on/off a disk cache
```
Visalto.shared.useDiskCache = false
```

It is also possible to customize image loading operation by setting 
* quality of service
* priority in the queue
* url request cache policy 
* url request timeout interval

```
Visalto.shared.loadImage(with: url,
                         qos: .userInteractive,
                         queuePriority: .high,
                         cachePolicy: .reloadIgnoringCacheData,
                         timeoutInterval: 20,
                         completionQueue: .main) { result in ... }
```

There is an associated project VisaltoShowcase which demonstrates the usage of the framework.

![alt Visalto](Visalto/showcase.png)
