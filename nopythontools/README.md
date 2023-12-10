## 5. Утилита добавления путей в autojump 

Есть такая утилита autojump, которая может добавлять каталоги, в которых вы уже побывали в историю, и потом, по короткому паттерну, позволяет получить к этому каталогу доступ.

Начальное стостояние списка каталогов может быть сформировано на основе истории. В случае если история не включает всех каталогов, возникате необходимость задавать каоманду cd в нужные каталоги.

С помощью данной утилиты есть возможность обойти все каталоги в указанном каталоге и добавить их в autojump

```
Usage: [ruby] autojumpadder.rb [options] absolute_path_to_folder_to_add_to_autojump
  Options:
    -h or --help             - this help
    -d or --dry or --dry-run - show only directories without adding to autojump
    -n or --new-only         - add only new directories
    -m                       - max directory scan depth, 0 - unlimited
    -e or --exclude          - exclude dirs: -e dir1,dir2,dir3
    -f or --file-exclude     - file of exludes dir list in format:
                             dir1 - can be one word or absolute path
                             dir2
                             ...
    -v                       - verbose
    -p                       - show progress bar
```

Примеры вызовов:

1. Добавление всех подкаталогов домашнего каталога:

```
ruby autojumpadder.rb /home/alexey
```

2. Но в предыдущей команде нужно быть аккуратным, если подкаталогов много, то команда будет выполняться долго и база autojump станет черезчур большой. Есть выход - ограничение глубины просмотра поддиректорий:
```
ruby autojumpadder.rb -m 3 /home/alexey
```
т.е. просматривать не глубже 3-ей поддиректории

3. Есть еще дополнительные фильтры - по наличию строки в каталоге, исключить все, что перечисленно в списке
```
ruby autojumpadder.rb -m 3 /home/alexey -e go,bin,qt,windows,rpmbuild,radare2,fcdtdebugger,sources,kernelcare,___
```

команда выше исключит все, что содержит в себе go,bin,qt и т.н. например такой каталог как /home/alexey/go или /home/alexey/helogo

4. Список исключаемых слов и каталогов можно положить в файл
```
ruby autojumpadder.rb /home/alexey -f exclude_dirs.lst
```

5. Если ранее уже запускалась утилита по добавлению каталогов, но уже появились новые, то можно запустить добавление только новых каталогов:
```
ruby autojumpadder.rb -n /home/alexey
```
это параметр -n, он скажет программе вначале получить список того, что есть, а потом вычислить, что есть новое и добавить

6. Если не доверяете тому списку каталогов, который создаст утилита, то можно ее запустить в режиме dry-run, т.е. список каталогов будет составлен, но программа просто выведет, какими командами и какие каталоги будут добавлены в базу, без самого действия добавления
```
ruby autojumpadder.rb -m 3 -d -n /home/alexey -e go,bin,qt,windows,rpmbuild,radare2,fcdtdebugger,sources,kernelcare,___ -v
```
Новый параметр -d и вывод:
```
[alexey@localhost tests]$ ruby autojumpadder.rb -m 3 -d -n /home/alexey -e go,bin,qt,windows,rpmbuild,radare2,fcdtdebugger,sources,kernelcare,___
Will be added directory /home/alexey/tmphome/sodovaya with command /home/alexey/.autojump/bin/autojump --stat
```
