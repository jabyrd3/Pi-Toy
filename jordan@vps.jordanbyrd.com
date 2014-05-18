<!DOCTYPE html>
    <head></head>
    <body>
        <canvas width="520" height="500" id="monte-1">
        	
        </canvas>
        <script type="text/javascript">
        var canvas = document.getElementById('monte-1');
        var context = canvas.getContext('2d');
        var width = 500;
        var height = 500;
		var panels = [];
		var matchSticks = [];
		var panelWalker = 0;
		var collisions = 0;
		function getRandomInt(min, max) {
		  return Math.floor(Math.random() * (max - min + 1) + min);
		}

        function matchStick(){
        	this.length = 20;
        	this.center = [getRandomInt(0,500), getRandomInt(0,500)];
        	this.rotation = getRandomInt(0, 360);
        }
        function panel(){
        	this.width = 40;
        	this.height = 500;
        }
        function collider(start, end, x){
        	if(start[0] < x && end[0] > x){
	        	console.log('first case', start,end,x);
        		return true;
        	}else if(start[0] > x && end[0] < x){
	        	console.log('second case', start,end,x);
        		return true;
        	}else{
        		return false;
        	}
        }
        for(i = 0; i <= 13; i++){
        	var poonel = new panel();
        	poonel.x = panelWalker;
        	panels.push(poonel);

        	context.beginPath();
        	context.moveTo(panelWalker, 0);
        	context.lineTo(panelWalker, poonel.height);
        	context.stroke();

        	panelWalker += poonel.width;
        }

        for (i = 0; i < 300; i++){
        	var matchDirk = new matchStick();
        	matchDirk.startPoint = [Math.cos( matchDirk.rotation ) * (-matchDirk.length / 2) + matchDirk.center[0],  Math.sin( matchDirk.rotation ) * (-matchDirk.length / 2) + matchDirk.center[1]];
        	matchDirk.endPoint = [Math.cos( matchDirk.rotation ) * (matchDirk.length / 2) + matchDirk.center[0], Math.sin( matchDirk.rotation ) * (matchDirk.length / 2) + matchDirk.center[1]];
        	matchSticks.push(matchDirk);

        	context.beginPath();
        	context.moveTo( matchDirk.startPoint[0], matchDirk.startPoint[1]);
        	context.lineTo( matchDirk.endPoint[0], matchDirk.endPoint[1]);
        	for(x = 0; x < panels.length; x++){
        		if(collider(matchDirk.startPoint, matchDirk.endPoint, panels[x].x) !== false){
	        		context.strokeStyle = "#ff0000";
	        		collisions++;
	        		break;
        		}else{
        			context.strokeStyle = "#000000";
        		}
        	}
        	context.stroke();
        	context.closePath();
        }
        console.log('collisions', collisions);
        </script>
    </body>
</html>
