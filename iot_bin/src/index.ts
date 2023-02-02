var { program } = require('commander');


program
    .name('mt')
    .command('create [name]', 'install one or more packages')
    .executableDir('../bin/')
program.parse();