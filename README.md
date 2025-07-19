## offline-infra

If you want transfer your offline registry to another server, you can create a tarball from `/verdaccio-bind-mount` 
folder. Then `scp` the tarball to the server. 

```sh
tar czfP www-user-hybrid.tar.gz ./verdaccio-bind-mount
```

Then use the following command to transfer verdaccio image to the destination server.
```sh
docker save verdaccio/verdaccio:nightly-master | gzip | ssh {{server}} docker load
```

So the whole infrastructure can be transferred without any connection to npmjs register or docker hub.


## `.npmrc`

Note, the `offline=true` option in consumer-project. This will make sure that if the package is not found locally, it won't request npmjs registry.

Alternatively, you can comment-out `proxy: npmjs` inside [verdaccio `config.yaml`](/verdaccio-bind-mount/conf/config.yaml). BUT then you **won't be able** to add new packages to verdaccio offline registry. When you want to install packages inside **consumer** projects and you're sure the package exists in verdaccio registry, then it is fine (& recommended) to comment out `proxy: npmjs` to make sure you have full offline experience.  

But, when you want to **fill verdaccio registry** with new packages, you should revert `proxy: npmjs` back. Then, head over `/registry-filler-project` and do npm install whatever package you desire. If the package is not found inside verdaccio registry, it will download it from registry.npmjs.com (note, `registry-filler-project/.npmrc` **does NOT** have ~~`offline`~~ option) AND verdaccio server will automatically put the package inside verdaccio storage (here they're stored inside `verdaccio-bind-mount/storage` folder).