# flu-tur
> This contains codebase for the flutter online course available at https://www.youtube.com/playlist?list=PLTsieZ1gJZTCU80dHA233sNsOp-epQtLL


# Chapter 1

This chapter introduce you to dart programming language and flutter. It cover basics of flutter, its architecture, design and building blocks of flutter - The Widgets.

# Chapter 2

In this chapter, you will learn how to create a MVC framework for your UI. You will also learn how to import bulk data to your application without afftecting user experience.

This chapter talks a lot about different design patterns, architectural concepts etc.

The last session in this chapter explains about EventEmitter - a utility we created to help us apply event driven development approach for data and UI.

Sample code for using EventEmitter is as follows.

``` Dart

StoreFactory().get("InventoryModel").addListener("onsave", onStoreChanged);

StoreFactory().get("InventoryModel").addListener("onload", onStoreChanged);

void onStoreChanged(String event, Object data) {
    debugPrint("Event $event received");
}

```

This will generate following when store is loaded.

    flutter: Event onload received

The following log will be generated when store is saved.

    flutter: Event onsave received

Another advantage is that you can use the MVC framework code to handle data efficiently in your code. When we are dealing with data, we just need to think about data only, not how it is going to be displayed on UI. Similarly, when we render UI, we should not worry how data is being read or loaded or saved. We used this separation of concers technique and with which you can create efficient code faster.

Example - Saving data to DB. Here UI can just call save and wait for store update notification. 

```Dart
InventoryModel m = new InventoryModel();
m.save();
```

>UI may display a progress indicator and block user from performing any operation until it receives notification from store.

UI can relay on this store notifcation to update its inner state or perform additional rendering logic.
