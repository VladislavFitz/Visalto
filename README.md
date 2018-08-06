# Visalto

![alt Visalto](Visalto/logo.png)

Visalto is a lightweight framework for asynchronous image loading from the web or a disk. 
It provides in-memory and disk caching functionalities.
The basic image loading looks as follows

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
The same interface may be used for loading an image from the disk and from the web.

For cancellation of an operation just call `cancelLoading` with the url that was used for its creation.

```
Visalto.shared.cancelLoading(for: url)
```

## Possible customizations

There are numerous parameters available for the customization of image loading behaviour.

Set your own custom URL session for remote image downloading.

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

It is also possible to customize each image loading operation by providing 
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

An associated project - VisaltoShowcase - demonstrates the usage of the framework.

![alt Visalto](Visalto/showcase.png)
