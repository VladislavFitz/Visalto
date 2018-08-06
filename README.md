# Visalto

![alt Visalto](Visalto/logo.png)

Visalto is lightweight framework for asynchronous image loading from web or disk URL. 
It uses memory and disk caching of images.


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

```
Visalto.shared.cancelLoading(for: url)
```

## Possible customizations

There are a lot of parameters for customization of framework

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

It is also possible to customize image loading operation by setting the quality of service, priority in the queue, url request cache policy and timeout interval
```
Visalto.shared.loadImage(with: url,
                         qos: .userInteractive,
                         queuePriority: .high,
                         cachePolicy: .reloadIgnoringCacheData,
                         timeoutInterval: 20,
                         completionQueue: .main) { result in ... }
```

There is an associated project VisaltoShowcase which demonstrates using of the framework.

![alt Visalto](Visalto/showcase.png)
