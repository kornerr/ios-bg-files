# Overview

This is a sample iOS application to monitor selected directory changes in background.

# Video

The video depicts adding/removing files using iTunes File sharing feature. iPhone is running iOS10.

![YouTube video](https://youtu.be/TtOMlzdXXL8)

# Preview

Here's a short preview if you can't open YouTube for some reason:

![Short preview](readme/preview.gif)


# Details

* Background execution is achieved by requesting 'Always' location updates.
* File changes are tracked with GCD descriptor dispatch source.
* Notifications are reported using local notifications.

# References

Here are some of the docs I used to implement the sample.

* Directory monitoring with GCD
  * https://habrahabr.ru/post/191868/
  * https://www.cocoanetics.com/2013/08/monitoring-a-folder-with-gcd/
* iOS background execution
  * https://habrahabr.ru/post/271505/
  * https://github.com/vaskravchuk/BGModesTest
