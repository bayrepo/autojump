## Utility for adding paths to autojump

There is an autojump utility that can add directories that you have already visited in history, and then, according to a short pattern, allows you to access this directory.

The initial state of the directory list can be generated based on the history. If the history does not include all directories, it becomes necessary to set the cd command to the desired directories.

With this utility, it is possible to bypass all directories in the specified directory and add them to autojump

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

Examples of calls:

1. Adding all subdirectories of the home directory:

```
ruby autojumpadder.rb /home/alexey
```

2. In previous case you need to be careful, if there are many subdirectories, then the command will jump out for a long time. There is a way to limiting the depth of viewing subdirectories:
```
ruby autojumpadder.rb -m 3 /home/alexey
```
i.e. view no deeper than the 3rd subdirectory

3. There are additional filters - by the presence of a line in the catalog, exclude everything that is listed in the list
```
ruby autojumpadder.rb -m 3 /home/alexey -e go,bin,qt,windows,rpmbuild,radare2,fcdtdebugger,sources,kernelcare,___
```

the command will exclude everything contains go,bin,qt, etc. an example is a directory like /home/alexey/go or /home/alexey/helogo

4. The list of excluded words and directories can be put in a file
```
ruby autojumpadder.rb /home/alexey -f exclude_dirs.lst
```

5. If the utility for adding directories has already been launched before, but new ones directories have already appeared, then you can start adding only new directories:
```
ruby autojumpadder.rb -n /home/alexey
```
in this case only new directories will be added ti the database

6. Utility can be started in dry-run mode, without adding directories to the database. Only shows what will be added:
```
ruby autojumpadder.rb -m 3 -d -n /home/alexey -e go,bin,qt,windows,rpmbuild,radare2,fcdtdebugger,sources,kernelcare,___ -v
```
The output will be:
```
[alexey@localhost tests]$ ruby autojumpadder.rb -m 3 -d -n /home/alexey -e go,bin,qt, windows,rpmbuild,radare2,fcdtdebugger,sources,kernelcare,___
The /home/alexey/tmphome/sodovaya directory will be added with the command /home/alexey/.autojump/bin/autojump --stat
```

## Утилита добавления путей в autojump 

Есть такая утилита autojump, которая может добавлять каталоги, в которых вы уже побывали в историю, и потом, по короткому паттерну, позволяет получить к этому каталогу доступ.

Начальное стостояние списка каталогов может быть сформировано на основе истории. В случае если история не включает всех каталогов, возникает необходимость задавать каоманду cd в нужные каталоги.

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
