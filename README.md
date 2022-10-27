# Observability in Selenium Grid

### Pre-requisites

* [Docker](https://www.docker.com/products/docker-desktop/) installed.

### Distributed Observable Grid

In order to bring up the **Distributed Observable Grid** do the following:

* Clone this repo.
* Now from the cloned repo's directory run the command : `docker-compose up -d`
* Now run the below sample test case.
* To bring down the distributed grid run `docker-compose down -v`

### Simple Observable Grid
In order to bring up the **Distributed Observable Grid** do the following:

* Clone this repo.
* Now from the cloned repo's directory run the command : `docker-compose -f docker-compose-v3.yml up -d`
* Now run the below sample test case.
* o bring down the simple grid run `docker-compose -f docker-compose-v3.yml down -v`


```java
import java.net.MalformedURLException;
import java.net.URL;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.RemoteWebDriver;

public class RunLocallyTestCase {

  public static void main(String[] args) throws MalformedURLException {
    RemoteWebDriver driver = null;

    try {
      URL url = new URL("http://localhost:4444");
      driver = new RemoteWebDriver(url, new ChromeOptions());
      driver.get("https://www.selenium.dev/");
      System.err.println("Title: " + driver.getTitle());
    } finally {
      if (driver != null) {
        driver.quit();
      }
    }
  }
}
```

* You can view the [Jaegar UI](http://localhost:16686/) and trace your request. 