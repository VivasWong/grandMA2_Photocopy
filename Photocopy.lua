local function Readme ()
    print('')
    print('* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *')
    print('*                          Photocopy v1.1.1                           *')
    print('*                                                                     *')
    print('*                 ----------------------------------                  *')
    print('*                          Created by Vivas                           *')
    print('*                 ----------------------------------                  *')
    print('*                    Contact : VivasWong@gmail.com                    *')
    print('*                                                                     *')
    print('*                       Last updated May 7,2019                       *')
    print('* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *')
    print('')
end

local get = gma.show.getobj
local cmd = gma.cmd

function getClass(str)
    return get.class(get.handle(str))
end

function getNumber(str)
    return get.number(get.handle(str))
end

function checkMac(str)
    if get.handle(str) == nil then return false
    end
end

function findfreemac()
    local m = 1 repeat
        local mhandle = get.handle('macro '..m)
        gma.feedback(mhandle)
        m = m + 1
    until(mhandle == nil)
    m = m - 1
    return m
end

function macmd(MacNum,LineNum,command)
    cmd('s ma 1.'..MacNum..'.'..LineNum)
    cmd('ass ma 1.'..MacNum..'.'..LineNum..' /cmd="'..command..'"')
end

function storeMac(m)
    cmd('s ma '..m..' "Photocopy by Vivas"')
    macmd(m,1,'SetVar $selexec0=$selectedexec ; Select @')
    macmd(m,2,'SetVar $selexec1=$selectedexec')
    macmd(m,3,'Select @')
    macmd(m,4,'SetVar $selexec2=$selectedexec')
    macmd(m,5,'Select Executor $selexec0')
    macmd(m,6,'SetVar $selexec0=')
    macmd(m,7,'Plugin Photocopy')
end

function print (msg)
    gma.echo(msg)
    gma.feedback(msg)
end

local function Photocopy()
    cmd('lab exec $selexec1 "PhotocopybyVivas"')
    if get.handle('Root *.*.PhotocopybyVivas') == nil then
        cmd('del exec $selexec1 /nc')
        gma.gui.msgbox('Error !!!','The Executor is empty !!!')
    else
        local exec1sequ = getNumber('Sequ PhotocopybyVivas')
        cmd('oops /nc')
        cmd('del exec $selexec2 /nc')
        if exec1sequ == nil then
            cmd('copy exec $selexec1 at exec $selexec2 /o')
            print('Copy done !')
        else
            cmd('store exec $selexec2 /o "PhotocopybyVivas"') 
            local exec2sequ = getNumber('Sequ PhotocopybyVivas')
            cmd('copy /o sequ '..exec1sequ..' at sequ '..exec2sequ)
            print('Photocopy done !')
        end
    end
end

return function ()
    cmd('lock plugin Photocopy')
    Readme ()
    if checkMac('ma "Photocopy by Vivas"') == false then
        local macNum = findfreemac()
        storeMac(macNum)
        if gma.gui.confirm('Error !','Please run macro "Photocopy by Vivas" first ! \n \n Do you want to run this macro right now ? ') == true then
            cmd('ma "Photocopy by Vivas"')
        else
            gma.echo('Please run macro "Photocopy by Vivas" first !')
        end
    else
        if get.handle('Root *.*.PhotocopybyVivas') == nil then
            Photocopy()
        else
            local checkclass = getClass('Root *.*.PhotocopybyVivas')
            local checknumber = getNumber('Root *.*.PhotocopybyVivas')
            print('Error !!! Please check the name of '..checkclass:sub(5)..' '..checknumber..' !!!')
            gma.gui.msgbox('Error !!!','Name repetition !!! \n \n Please check the name of '..checkclass:sub(5)..' '..checknumber..' !!!')
        end
    end
    gma.show.setvar('selexec1','')
    gma.show.setvar('selexec2','')
    gma.echo('Plugin done !')
end