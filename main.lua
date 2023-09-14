local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local physics = require("physics")

physics.start()
--physics.setDrawMode( "hybrid" )
physics.setGravity(0,20)
local memoria = {}

local atacando = false


function jsonFile( filename, base )
        -- set default base dir if none specified
        if not base then base = system.ResourceDirectory; end
        
        -- create a file path for corona i/o
        local path = system.pathForFile( filename, base )
        print( "jsonFile ["..path.."]" )
        
        -- will hold contents of file
        local contents
        
        -- io.open opens a file at path. returns nil if no file found
        local file = io.open( path, "r" )
        if file then
           -- read all contents of file into a string
           contents = file:read( "*a" )
           io.close( file )     -- close the file after using it
        else
                print( "** Error: cannot open file" )
        end
        
        print( "contents<<<EOF")
        print( contents )
        print( ">>EOF")
        
        return contents
end





local json = require "json"
local t = json.decode( jsonFile( "sample.json" ) )
--print(t["42"])



inTarget=false
target = _W-100



local bkg = display.newImage( "background11.png", centerX, centerY )  

local bullet
local bulletEn
local bullets = display.newGroup()
local player = display.newCircle( 50 , centerY, 25 )
physics.addBody( player , "dinamic" , { density = 0 , friction = 0, bounce = 0 , radius = 25 })
player.hp = 5

player.myName="player"

local en = display.newCircle(  _W/2+200 , 520, 25 )
physics.addBody( en , "dinamic" , { density = 0 , friction = 2.0, bounce = 0 , radius = 25 })
en.hp = 10
en:setFillColor("black")
en.myName="enemy"

playerHp = display.newText( "player hp:  ".. player.hp, display.contentCenterX - 50 , 40 , native.systemFontBold, 26 )
--playerHp:setFillColor( "white" )

enHp = display.newText( "enemy hp:  "..en.hp ,  display.contentCenterX + 180 , 40 , native.systemFontBold, 26 )
--playerHp:setFillColor( "white" )




function touched(event)


 if ( event.phase=="began"  ) then
 player:setLinearVelocity(0,0)
 if ( event.x < player.x )then
 
 esq = true
 

 player:setLinearVelocity( -300 ,0)
 --player:applyLinearImpulse( -0.3 , 0 ,  player.x , player.y )
  end
 
 if ( event.x > player.x )then
 

 esq = false
 
 player:setLinearVelocity( 300 ,0)
 --player:applyLinearImpulse( 0.3 , 0 ,  player.x , player.y )
  end
 
 
 end

end




 local function onLocalCollision2( self, event )
     -- Aqui ele popula o array quando a bola toca o chao ou o player
    if ( event.phase == "began" ) then
      if ( event.other.myName == "chao") then
  --memoria[math.round( self.x )] = self  -- Popula o array memoria
  --print("normdeltaX:  "..memoria[math.round(self.x)].normX )
  --print("normdeltaY:  "..memoria[math.round(self.x)].normY )
  --print("target :  "..memoria[math.round(self.x)].targetX )
    display.remove(self)

end
       
if(event.other.myName=="player")then

       player.hp = player.hp -1
        display.remove(self) 

      end 

  if(event.other.myName=="enemy")then

        en.hp = en.hp - 1
        display.remove(self)

  end     


end
end


 local function onLocalCollision( self, event )
     
    if ( event.phase == "began" ) then
      if ( event.other.myName == "chao") then
  --memoria[math.round( self.x )] = self  -- Popula o array memoria
  --print("normdeltaX:  "..memoria[math.round(self.x)].normX )
  --print("normdeltaY:  "..memoria[math.round(self.x)].normY )
  --print("target :  "..memoria[math.round(self.x)].targetX )


display.remove(self)

end

  if(event.other.myName=="player")then

        player.hp = player.hp -1
        display.remove(self) 

      end 

 if(event.other.myName=="enemy")then

        en.hp = en.hp - 1
        display.remove(self)

  end 


end

end




function launch(event)
 if ( event.phase=="began" or event.phase == "moved" ) then
 -- Tentar isso tambem if(event.phase == "began" or event.phase == "moved") then
 display.getCurrentStage():setFocus(player)
 player:setLinearVelocity(0,0)
 
 
 elseif event.phase == "ended" then

 
deltaX = event.x - player.x
deltaY = event.y - player.y
normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))

    -- sin, cos = math.sin( angle ), math.cos( angle )

    -- sinT.text = sin
    -- cosT.text = cos
 

    bullet = display.newCircle( 0 , 0, 15 )
    bullet.x = player.x
    bullet.y = player.y-50

  bullet.collision = onLocalCollision
  bullet:addEventListener( "collision", bullet )
  --bullet.myName="shoot"

    physics.addBody( bullet )
    bullets:insert(bullet)  
 

 bullet:applyLinearImpulse(((event.xStart - event.x)/100) , ((event.yStart - event.y)/100 ) , bullet.x , bullet.y )

 display.getCurrentStage():setFocus(nil)
 
 end
 
 end







local borderBottom = display.newRect( 0, 550, _W*2, 20 )
borderBottom:setFillColor( 1, 1, 1, 1)    -- make invisible
physics.addBody( borderBottom, "static", borderBodyElement )
borderBottom.myName="chao"
borderBottom.collision=onLocalCollision




local middleBottom = display.newRect( _W/2, _H+10, 20, 600 )
middleBottom:setFillColor( 1, 1, 1, 1)    -- make invisible
physics.addBody( middleBottom , "static", borderBodyElement )

 local borderLeft = display.newRect( 0, 0, 20 , _H*2 )
borderLeft:setFillColor("black" )    -- make invisible
physics.addBody( borderLeft, "static", borderBodyElement )



local borderRight = display.newRect( _W , 20, 20, _H*2 )
borderRight:setFillColor("black")   -- make invisible
physics.addBody( borderRight, "static", borderBodyElement )


local borderTop1 = display.newRect( 0, 0, _W*2 , 20 )
borderTop1:setFillColor( "black")    -- make invisible
physics.addBody( borderTop1, "static", borderBodyElement ) 


function hasBullet()


for i=bullets.numChildren,1, -1 do 

if (bullets[i].x > _W/2) then

if(bullets[i].y>250)then

if(bullets[i].x>en.x)then

en:setLinearVelocity( math.random( 100, 500)*-1, 0 )
--n = math.random(0,10)
--if(math.random(0,10) > 7 )then en:setLinearVelocity(math.random(100,500) , 0 ) end


 end 

if(bullets[i].x<en.x)then
 --en:applyLinearImpulse(0.1 ,0)
 en:setLinearVelocity(math.random(100,500) , 0 )

--if(math.random(0,10) > 7 )then en:setLinearVelocity(math.random(100,500)*-1 , 0 ) end


 end 



 end 



end


end

end


function atack()

deltaX = player.x - en.x
deltaY = math.random(0,30) - player.y
--deltaY = math.random(0,90) - player.y


normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))

    -- sin, cos = math.sin( angle ), math.cos( angle )

    -- sinT.text = sin
    -- cosT.text = cos
 

    bulletEn = display.newCircle( 0 , 0, 15 )
    bulletEn.x = en.x
    bulletEn.y = en.y-50

    bulletEn.normX = normDeltaX
    bulletEn.normY = normDeltaY
    bulletEn.targetX = en.x
    --bulletEn.isVisible = false   

  bulletEn.collision = onLocalCollision2
  bulletEn:addEventListener( "collision", bulletEn )
  
   physics.addBody( bulletEn )
    bullets:insert(bulletEn)
    --bullets.isVisible=false  
  

    --physics.addBody( bullet )
    --bullets:insert(bullet)  
 

 bulletEn:applyLinearImpulse(((normDeltaX * 30)/100) , ((normDeltaY * 30 )/100 ) , bulletEn.x , bulletEn.y )

--bullet:applyLinearImpulse(((normDeltaX * math.random(0,30) )/math.random(50,100)) , ((normDeltaY * math.random(0,30) )/math.random(50,100)) , bullet.x , bullet.y )


end


function ataca(nx , ny)
if(atacando==false)then
  atacando = true
    bulletEn = display.newCircle( 0 , 0, 15 )
    bulletEn.x = en.x
    bulletEn.y = en.y-50

   
    --bulletEn.isVisible = false   

  bulletEn.collision = onLocalCollision2
  bulletEn:addEventListener( "collision", bulletEn )
  
   physics.addBody( bulletEn )
    bullets:insert(bulletEn)
    --bullets.isVisible=false  
  

    --physics.addBody( bullet )
    --bullets:insert(bullet)  
 
 print("nx :"..nx)
 print("ny :"..ny)
 bulletEn:applyLinearImpulse(((nx * 30)/100)  , ((ny * 30 )/100 )  , bulletEn.x , bulletEn.y )
 
--bullet:applyLinearImpulse(((normDeltaX * math.random(0,30) )/math.random(50,100)) , ((normDeltaY * math.random(0,30) )/math.random(50,100)) , bullet.x , bullet.y )
timer.performWithDelay( 5000 , function()


atacando = false

  end, 1 )


end




end





function atack2()


deltaX = player.x - en.x
deltaY = math.random(0,30) - player.y
normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))

    bullet = display.newCircle( 0 , 0, 15 )
    bullet.x = en.x
    bullet.y = en.y-50

    bullet.normX = normDeltaX 
    bullet.normY = normDeltaY
    bullet.target = en.x -- o lugar onde ele vai lançar com os dados de lançamento

  bullet.collision = onLocalCollision2
  bullet:addEventListener( "collision", bullet )
  

    physics.addBody( bullet )
    bullets:insert(bullet) 
    bullets.isVisible=false 
 


--[[


applyLinearImpulse( valueX , valueY , bullet.targetX , bullet.targetY )

valueX = 


]]



end



function getTarget()


if(en.x <= target)then
 target = _W/2+50
end
if(en.x >= target)then
 target = _W -100
end



--target = math.random( _W/2+50, _W-100)
--inTarget = true -- Ele estará intarget e não terá o fluxo interrompido



end






function go(target, nx , ny )

--print(inTarget)

--[[

if(inTarget==false)then-- Se ela não estiver em trajeto ela fará
--getTarget()
 
if(target>en.x)then
en:setLinearVelocity(300,0)
if( en.x <= target)then -- Quando chegar no trajeto ataca
en:setLinearVelocity(0,0)
print(target)  
ataca( nx , ny)

--en:setLinearVelocity(0,0)
 -- Leva player.x que é o indice do array mapeado das jogadas..
--inTarget=false

end
end


if(target < en.x)then
en:setLinearVelocity(-300,0)
if(en.x >= target)then -- Quando chegar no trajeto ataca
en:setLinearVelocity(0,0)
print(target) 
ataca( nx , ny)
--en:setLinearVelocity(0,0)
 -- Leva player.x que é o indice do array mapeado das jogadas..
--inTarget=false

end
end
--]]




--if(en.x == target)then -- Quando chegar no trajeto ataca
--atack()
--en:setLinearVelocity(0,0)
 -- Leva player.x que é o indice do array mapeado das jogadas..
--inTarget=false

--end

transition.moveTo( en, { x= target, y=en.y, time=math.random(500,1000) , onComplete=ataca( nx , ny ) } )

end


function respawn()

 bulletEn = display.newCircle( 0 , 0, 15 )
    bulletEn.x = player.x
    bulletEn.y = 200

   
    --bulletEn.isVisible = false   

  bulletEn.collision = onLocalCollision2
  bulletEn:addEventListener( "collision", bulletEn )
  
   physics.addBody( bulletEn )
    bullets:insert(bulletEn)



 end 




function update()
--mapeia()
playerHp.text="player hp:  "..player.hp
enHp.text="enemy hp:  "..en.hp
--timer.performWithDelay( math.random(2100,2700), hasBullet , 1 )
timer.performWithDelay( 2000 , hasBullet , 1 ) -- checa onde tem bala

 


if(  t[tostring(math.round(player.x))] ~= nil )then print("Tem coordenada")
  
print( t[tostring(math.round(player.x))].targetX)
if ( atacando == false )then
go(t[tostring(math.round(player.x))].targetX , t[tostring(math.round(player.x))].normX , t[tostring(math.round(player.x))].normY )
end
--go( t[tostring(math.round(player.x))].targetX , t[tostring(math.round(player.x))].normX , t[tostring(math.round(player.x))].normY )
--transition.moveTo( en, { x=t[tostring(math.round(player.x))].targetX, y=en.y, time=1000 , onComplete=ataca(t[tostring(math.round(player.x))].normX , t[tostring(math.round(player.x))].normY) } )

 end

hasBullet()

end



function targets()
n = math.random(0,5)
if( n > 2 )then inTarget = true end
if( n < 2 )then inTarget = false end
print(inTarget)

end




  --timer.performWithDelay( 1500 , ataca, -1 )
--timer.performWithDelay( 1500 , atack, -1 )
--timer.performWithDelay( 10 , atack2 , 50 )
--timer.performWithDelay( 1 , mapeia , 500 )
--timer.performWithDelay( 3000 , atack , -1 )
timer.performWithDelay( 5000 , respawn , -1 )
player:addEventListener("touch",launch)
Runtime:addEventListener("touch",touched)
timer.performWithDelay(1 , update , -1 )
--timer.performWithDelay(2000 , targets , -1)





