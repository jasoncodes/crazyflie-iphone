# Crazyflie

![](http://cl.ly/image/09010a201s0l/content)

## Development

Download and install RubyMotion.

Copy the example YAML file and set your hostname:

``` sh
cp config.example.yml config.yml
```

Install the required gems:

```
bundle install
```

Start the app:

``` sh
rake
# or
rake device
```

Start [crazyflie-server] or debug with a dummy server:

``` sh
cd ~/projects/crazflie-server
./server.py
# or
socat UDP4-RECVFROM:63251,fork stdio
```

## Contributors

* Odin Dutton ([twe4ked])
* Jason Weathered ([jasoncodes])

[jasoncodes]: https://github.com/jasoncodes
[twe4ked]: https://github.com/twe4ked
[crazyflie-server]: https://github.com/jasoncodes/crazyflie-server
