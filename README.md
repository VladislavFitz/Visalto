# Visalto

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
