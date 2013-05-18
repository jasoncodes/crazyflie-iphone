# Crazyflie

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

rake

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
[crazflie-server]: https://github.com/jasoncodes/crazyflie-server
