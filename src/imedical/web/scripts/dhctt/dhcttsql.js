var tip,propertyTip,Query,textTip,consoleDivObj,consoleTblObj,consoleBtn;
var tableSet = {};
DHC.TextTip = function ( config ){
	this.active = true ;
	this.div = null;	
	this.div = document.createElement("div");
	this.div.style.display = "none";
	this.div.zIndex = 12;
	//this.div.style.width="200px";
	//this.div.style.height="120px";
	this.div.className = arguments.length>0 ? (config.className || "tipDiv") : "tipDiv";				
	document.body.appendChild(this.div);	
};
DHC.TextTip.prototype = {
	show : function (text,xy){
		if(!this.active) return ;
		if("undefined" !== typeof text && text) this.div.innerHTML = text;		
		if("undefined" !== typeof xy && (xy instanceof Array)) {
			//this.div.style.pixelLeft = xy[0] ; 
			//this.div.style.pixelTop = xy[1];
			this.div.style.left = xy[0] ; 
			this.div.style.top = xy[1];
			this.div.style.position = "absolute";
		}
		this.div.style.display = "" ;
		this.isShow = true;
		DHC.isIE? "" : this.div.tabIndex = 0 ;
		this.div.focus();		
	},
	hide : function (){
		if(!this.active) return ;	
		this.div.style.display = "none";
		this.isShow = false;
	},
	on : function(){
		var tmp = this;		
		DHC.addEventListener( tmp.div, "blur", function(a){return function(){a.hide();}}(tmp) );
	}
}
var queryKeyDownHandler = function(e){
	//var startEndArr = DHC.getTextAreaPlace(Query);
	if(tip.isShow){
		var keyCode = DHC.getKeyCode(e);
		if(keyCode==40) DHC.stopEvent(e);
	}	
};
var queryKeyUpHandler = function(e){
	var keyCode = DHC.getKeyCode(e);
	var tmpobj,tipTypeObj={},lastString="",tmparr=[];
	/** 187 =, 222 ' " , 190 >, 180 <, 16 Shift, 20 Capslk, 18 Alt, */
	if([187,222,180,16,190,20,18].indexOf(keyCode)>-1){return false;}		
	var sqlstr = SqlParser.getSQLStatement(Query.value);
	var startEndArr = DHC.getTextAreaPlace(Query);			
	if (DHC.isAltKey()&& keyCode==191) {		
		/** alt+/	 */
		tipTypeObj = SqlParser.getInputTypes(sqlstr,startEndArr[1]-1);
		//console.log(tipTypeObj.type+","+tipTypeObj.schema+","+tipTypeObj.table);
		lastString = tipTypeObj.value;
		switch (tipTypeObj.type){
			case Types.KEYWORD:
				tip.setArrayStore(SqlParser.Keywords,lastString);
				tip.show();
				break;
			case Types.SCHEMA:
				tip.setArrayStore(SCHEMAARR,lastString);
				tip.show();
				break;
			case Types.TABLE:
				if (!tableSet[tipTypeObj.schema]) {
					DHC.Ajax.req({
						url: "dhctt.request.csp", 
						data: {schema: tipTypeObj.schema, table: lastString, act:"getAllTable"}, 
						type:"GET", 		
						async: true,
						dataType: "json",
						success: function handler(obj){
							tableSet[obj.schema] = obj.data;
							tip.setArrayStore(tableSet[obj.schema].concat(SCHEMAARR),lastString);
							tip.show(); 
						}
					})
				}else{
					tip.setArrayStore(tableSet[tipTypeObj.schema].concat(SCHEMAARR),lastString);
					tip.show();
				}				
				break;
			case Types.COLUMN:
				/**表名不在tableSet[schema]中,则提示表名*/
				//if(tableSet[tipTypeObj.schema]&&tableSet[tipTypeObj.schema].indexOf(tipTypeObj.table)==-1){
				/*if(tableSet[tipTypeObj.schema]&&tableSet[tipTypeObj.schema][tipTypeObj.table]){
					tmparr = tableSet[tipTypeObj.schema].concat(SCHEMAARR,SqlParser.Keywords);
					tip.setArrayStore(tmparr,lastString);
					tip.show();
				}
				if(tableSet[tipTypeObj.schema] && tableSet[tipTypeObj.schema][tipTypeObj.table]){
					//[columns,tables,schemas]
					tmparr = tableSet[tipTypeObj.schema][tipTypeObj.table].concat(tableSet[tipTypeObj.schema],SqlParser.Keywords);
					tip.setArrayStore(tmparr,lastString);
					tip.show();
				}*/
				
				if(tableSet && tableSet[tipTypeObj.schema]
					&& tableSet[tipTypeObj.schema].indexOf(tipTypeObj.table)>-1 
					&& columnSet[tipTypeObj.table] && columnSet[tipTypeObj.table].length>1){
					tip.setArrayStore(columnSet[tipTypeObj.table],lastString);
					tip.show();
				}else{
					DHC.Ajax.req({
						url: "dhctt.request.csp", 
						data: {schema: tipTypeObj.schema, table: tipTypeObj.table,column:lastString,act:"getTableAllColumn"}, 
						type:"GET", 		
						async: true,
						dataType: "json",
						success: function handler(obj){
							
							if(!obj.table){	/*返回的是表集合*/
								tableSet[obj.schema] = obj.data;
								tmparr = tableSet[obj.schema].concat(SCHEMAARR,SqlParser.Keywords);											
							}else{
								if(!tableSet[obj.schema]){
									tableSet[obj.schema] = [];									
								}
								tableSet[obj.schema].concat(obj.table);		
								columnSet[obj.table] = obj.data;							
								tmparr = columnSet[obj.table];
								//tmparr = tableSet[obj.schema][obj.table].concat(tableSet[obj.schema],SCHEMAARR,SqlParser.Keywords);
							}	
							if (["where","and","select"].indexOf(lastString)>-1) lastString="";						
							tip.setArrayStore(tmparr,lastString);
							tip.show(); 
						}
					});
				}				
				break;
				
			case Types.REF:
				if(tipTypeObj.schema&&tipTypeObj.table){				
					DHC.Ajax.req({
						url: "dhctt.request.csp", 
						data: {schema: tipTypeObj.schema, table: tipTypeObj.table,column:lastString,act:"getREFColumn"}, 
						type:"GET", 		
						async: true,
						dataType: "json",
						success: function handler(obj){
							if(!tableSet[obj.schema]){
								tableSet[obj.schema]={};							
							}						
							tableSet[obj.schema][obj.table] = obj.data;
							tmp = lastString.slice(lastString.lastIndexOf("->")+2)
							tip.setArrayStore(obj.data,tmp);
							tip.show(); 
						}
					});
				}
				break;				
			default:
				break;	
		}
		/** 写一全局变量来保存模式,表字,段*/
	}else if(keyCode === 40){	//向下键头
		if(tip.isShow){
			tip.select.focus();
			tip.select.selectedIndex = 0;
		}else{
			tip.show();
		}		
	}else{
		if(tip.isShow){
			lastString = SqlParser.getLastWord(sqlstr,startEndArr[1]-1);
			if(lastString.indexOf("->")>-1) lastString = lastString.slice(lastString.lastIndexOf("->")+2);
			tip.updatePreValue(lastString);
		}
	}
	return DHC.eventCancel();
}

var queryKeyUpHandler = function(e){
	var keyCode = DHC.getKeyCode(e);
	var tmpobj,tipTypeObj={},lastString="",tmparr=[];
	/** 187 =, 222 ' " , 190 >, 180 <, 16 Shift, 20 Capslk, 18 Alt, */
	if([187,222,180,16,190,20,18].indexOf(keyCode)>-1){return false;}		
	var sqlstr = SqlParser.getSQLStatement(Query.value);
	var startEndArr = DHC.getTextAreaPlace(Query);			
	if (DHC.isAltKey()&& keyCode==191) {		
		/** alt+/	 */
		tipTypeObj = SqlParser.getInputTypes(sqlstr,startEndArr[1]-1);
		//console.log(tipTypeObj.type+","+tipTypeObj.schema+","+tipTypeObj.table);
		lastString = tipTypeObj.value;
		switch (tipTypeObj.type){
			case Types.KEYWORD:
				tip.setArrayStore(SqlParser.Keywords,lastString);
				tip.show();
				break;
			case Types.SCHEMA:
				tip.setArrayStore(SCHEMAARR,lastString);
				tip.show();
				break;
			case Types.TABLE:
				if (true){ //(!tableSet[tipTypeObj.schema]) {
					DHC.Ajax.req({
						url: "dhctt.request.csp", 
						data: {schema: tipTypeObj.schema, table: lastString, act:"getAllTable"}, 
						type:"GET", 		
						async: true,
						dataType: "json",
						success: function handler(obj){
							tableSet[obj.schema] = obj.data;
							tip.setArrayStore(tableSet[obj.schema].concat(SCHEMAARR),lastString);
							tip.show(); 
						}
					})
				}else{
					tip.setArrayStore(tableSet[tipTypeObj.schema].concat(SCHEMAARR),lastString);
					tip.show();
				}				
				break;
			case Types.COLUMN:
				/**表名不在tableSet[schema]中,则提示表名*/
				//if(tableSet[tipTypeObj.schema]&&tableSet[tipTypeObj.schema].indexOf(tipTypeObj.table)==-1){
				/*if(tableSet[tipTypeObj.schema]&&tableSet[tipTypeObj.schema][tipTypeObj.table]){
					tmparr = tableSet[tipTypeObj.schema].concat(SCHEMAARR,SqlParser.Keywords);
					tip.setArrayStore(tmparr,lastString);
					tip.show();
				}
				if(tableSet[tipTypeObj.schema] && tableSet[tipTypeObj.schema][tipTypeObj.table]){
					//[columns,tables,schemas]
					tmparr = tableSet[tipTypeObj.schema][tipTypeObj.table].concat(tableSet[tipTypeObj.schema],SqlParser.Keywords);
					tip.setArrayStore(tmparr,lastString);
					tip.show();
				}*/
				
				if(tableSet && tableSet[tipTypeObj.schema]
					&& tableSet[tipTypeObj.schema].indexOf(tipTypeObj.table)>-1 
					&& columnSet[tipTypeObj.table] && columnSet[tipTypeObj.table].length>1){
					tip.setArrayStore(columnSet[tipTypeObj.table],lastString);
					tip.show();
				}else{
					DHC.Ajax.req({
						url: "dhctt.request.csp", 
						data: {schema: tipTypeObj.schema, table: tipTypeObj.table,column:lastString,act:"getTableAllColumn"}, 
						type:"GET", 		
						async: true,
						dataType: "json",
						success: function handler(obj){
							
							if(!obj.table){	/*返回的是表集合*/
								tableSet[obj.schema] = obj.data;
								tmparr = tableSet[obj.schema].concat(SCHEMAARR,SqlParser.Keywords);											
							}else{
								if(!tableSet[obj.schema]){
									tableSet[obj.schema] = [];									
								}
								tableSet[obj.schema].concat(obj.table);		
								columnSet[obj.table] = obj.data;							
								tmparr = columnSet[obj.table];
								//tmparr = tableSet[obj.schema][obj.table].concat(tableSet[obj.schema],SCHEMAARR,SqlParser.Keywords);
							}	
							if (["where","and","select"].indexOf(lastString)>-1) lastString="";						
							tip.setArrayStore(tmparr,lastString);
							tip.show(); 
						}
					});
				}				
				break;
				
			case Types.REF:
				if(tipTypeObj.schema&&tipTypeObj.table){				
					DHC.Ajax.req({
						url: "dhctt.request.csp", 
						data: {schema: tipTypeObj.schema, table: tipTypeObj.table,column:lastString,act:"getREFColumn"}, 
						type:"GET", 		
						async: true,
						dataType: "json",
						success: function handler(obj){
							if(!tableSet[obj.schema]){
								tableSet[obj.schema]={};							
							}						
							tableSet[obj.schema][obj.table] = obj.data;
							tmp = lastString.slice(lastString.lastIndexOf("->")+2)
							tip.setArrayStore(obj.data,tmp);
							tip.show(); 
						}
					});
				}
				break;				
			default:
				break;	
		}
		/** 写一全局变量来保存模式,表字,段*/
	}else if(keyCode === 40){	//向下键头
		if(tip.isShow){
			tip.select.focus();
			tip.select.selectedIndex = 0;
		}else{
			tip.show();
		}		
	}else{
		if(tip.isShow){
			lastString = SqlParser.getLastWord(sqlstr,startEndArr[1]-1);
			if(lastString.indexOf("->")>-1) lastString = lastString.slice(lastString.lastIndexOf("->")+2);
			tip.updatePreValue(lastString);
		}
	}
	return DHC.eventCancel();
}
function propertyClickHandler(t){
	var propertyName = t.innerText;
    var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
    var scrollY = document.documentElement.scrollTop || document.body.scrollTop;
    var mouseX = window.event.clientX + scrollX;
    var mouseY = window.event.clientY + scrollY;     
	//var mouseX = window.event.clientX;
	//var mouseY = window.event.clientY;
	DHC.Ajax.req({
		url: "dhctt.request.csp", 
		data: {P1:pojoPackageName+"."+pojoClassName , P2: propertyName,act:"getPropertyPiece"}, 
		type:"GET", 		
		async: true, 
		success: function handler(obj){
			var arr = obj.split("!");
			var master = masterIndex.replace(/{|}/g,"");
			var str = "<table>";
			var type = "";
			if(arr[3]!=""){
				if(arr[1]!=""){
					master = master.slice(0,master.length-1)+","+arr[1]+")";	//add node
				}				
				str = str+"<tr><td>取值语句:</td><td> s "+arr[0]+" = $p("+master+",\""+arr[2]+"\""+","+arr[3]+")</td></tr>"
				str = str+"<tr><td>PLIST位置: </td><td>"+arr[5]+"</td></tr>";
			}else{
				str +="<tr><td></td><td>没有定义分割位</td></tr>"
			}
			if(arr[4]!=""){
				type = arr[4];
				if(arr[4].indexOf("%")==-1){
					var pointIndex = arr[4].lastIndexOf("."); 
					var typePackageName = arr[4].slice(0,pointIndex);
					var typeClassName = arr[4].slice(pointIndex+1);
					type = "<a target='_blank' href='dhctt.findtablestructure.csp?packageName="+typePackageName+"&tableName="+typeClassName+"'>"+arr[4]+"</a>"
				}
				str += "<tr><td>字段类型: </td><td>"+type +"</td><td><a href='#' title='关闭' onclick='textTip.hide();'>X</a></td></tr>"
			}
			str += "</table>"
			textTip.show(str,[mouseX,mouseY+15]);
		}
	})
}
var consoleBtnClickHandler = function(){
	//consoleDivObj;
	if(consoleBtn.innerText == "+"){ 
		consoleBtn.innerText = "-";
		consoleBtn.title = "收起";
		consoleDivObj.className = "console-x2";
	}else{
		consoleBtn.innerText = "+";
		consoleBtn.title = "展开";
		consoleDivObj.className = "console-x1";
	}	
}
/*
     id 你要滚动的内容的id
     l 横坐标的位置  不写为紧贴右边
     t 你要放在页面的那个位置默认是贴着底边 0是贴着顶边
     f 1表示固定 不写或者0表示滚动
    */
function scroll(p){
	var d = document,dd = d.documentElement,db = d.body,w = window,o = d.getElementById(p.id),ie = /msie/i.test(navigator.userAgent),style,timer;
	if(o){
		//ie8下position:fixed下top left失效
		o.style.cssText +=";position:"+(p.f&&!ie?'fixed':'absolute')+";"+(p.l==undefined?'right:0;':'left:'+p.l+'px;')+(p.t!=undefined?'top:'+p.t+'px':'bottom:0');
		if(p.f&&ie){
			o.style.cssText +=';left:expression(body.scrollLeft + '+(p.l==undefined?db.clientWidth-o.offsetWidth:p.l)+' + "px");top:expression(body.scrollTop +'+(p.t==undefined?db.clientHeight-o.offsetHeight:p.t)+'+ "px" );'
			db.style.cssText +=";background-image:url(about:blank);background-attachment:fixed;"
		}else{
			if(!p.f){
				w.onresize = w.onscroll = function(){
					clearInterval(timer);
					timer = setInterval(function(){
						var st = db.scrollTop,c;
						c = st  - o.offsetTop + (p.t!=undefined?p.t:(w.innerHeight||db.clientHeight)-o.offsetHeight);
						if(c!=0){
							o.style.top = o.offsetTop + Math.ceil(Math.abs(c)/10)*(c<0?-1:1) + 'px';
						}else{
							clearInterval(timer);  
						}
					},10)
				}
			}
		}	
	}		
}
var tableClickRowHandler = function(e){		
	var src = DHC.getTarget(e);	
	var row = DHC.getRow(src);
	if(row){		
		DHCTable.selectRow(row);
	}
	var colNo = 0;

	var className = src.getAttribute("class");
	var schemaTableName = "";
	if(className=="tipitem"){
		var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
    	var scrollY = document.documentElement.scrollTop || document.body.scrollTop;
    	var mouseX = window.event.clientX + scrollX;
    	var mouseY = window.event.clientY + scrollY;
		var colNo = src.getAttribute("col");
		var input = document.getElementById("colz"+colNo);
		var schemaTableName = input.value;
		var colValue = src.innerText;
		DHC.Ajax.req({
			url: "dhctt.request.csp", 
			data: {schemaTable:schemaTableName, idValue: colValue,act:"getTableValueByID"}, 
			type:"GET", 		
			async: true,
			dataType: "json", 
			success: function handler(obj){
				var strArr = ["<div style='height:250px;width:400px; overflow: auto'>","<table>","<tr><td>属性</td><td>值</td></tr>"];
				for (var pro in obj) {
					if(pro){
						item = "<tr><td>"+pro+"</td><td>"+obj[pro]+"</td></tr>";
						strArr.push(item);
					}
				}
				strArr.push("</table></div>");				
				var str = strArr.join("");
				textTip.show(str,[mouseX,mouseY+15]);
			}
		});
	}
}
var updateOnblur = function(e){
	var t = $(e);
	if(t){
		if (t.val()==t.data("oldval")){ t.parent().text(t.val()); return ;}
		var tname = $("#tn").text();
		var iname = $("#in").text();
		//var sqlStr = "update "+tname+" set "+t.data("cn")+"=\""+t.val()+"\" where "+iname+"=\""+t.data("id")+"\"";
		
		var RuntimeMode = $("#RuntimeMode").val();
		$.ajax({
	        url: "dhctt.request.csp", 
	        data: {tname:tname,cname:t.data("cn"),cval:encodeURIComponent(t.val()),ival:t.data("id"),act:"updateSql",RuntimeMode:RuntimeMode}, 
	        type: "POST",
	        success: function handler(txt){
		        if (txt.indexOf("1 Row Affected")>-1) {
			        t.parent().text(t.val());
		        }
	        }
	    });
	}
}
var tabledblClickRowHandler = function(e){		
	var src = DHC.getTarget(e);
	if (src.cellIndex==0){
		return ;
	}	
	if (src.className && src.className.indexOf("rowidcol")>-1){
		return;
	}
	var row = DHC.getRow(src);
	if(row){		
		DHCTable.selectRow(row);
	}
	var tableObj = DHC.getTable(src);
	
	//var tableJObj = $("#resultSetTable");
	//var tn = tableJObj.data("tn");
	//tableJObj.find("tr th:eq("+src.cellIndex+") a").data("cn");
	
	var cn = $(tableObj.rows[0].cells[$(src).find("a").attr("col")]).find("a").data("cn");
	
	var id = $(row.cells[0]).data("id");
	if (id!=""){
		$(src).html("<input data-cn='"+cn+"' data-id='"+id+"' data-oldval='"+src.innerText+"' value='"+src.innerText+"' onblur='updateOnblur(this)'/>");
		$(src).find("input").select();
	}else{
		alert("没有Id列,无法快速更新!");
	}
} 
DHC.onReady(function(){	
	if (typeof columnSet == "undefined") columnSet={};
	Query = document.getElementById("Query");	
	tip = new DHC.Tip();
	tip.SelectedAddText = true;
	tip.DefaultPreTest = "SELECT * FROM "
	var tnwidth = "250px";	   	
	tip.renderTo(Query);
	tip.addSelect({},{
		style: {width: tnwidth},
		size: 12
	});
	var resultWidth = $(document).width()-50;
	var resultHeight = $(document).height()-220;
	$("#resultSetDiv").width(resultWidth).height(resultHeight);
	tip.SelectedEnterCallBack = function(selectedDom){		
		/*if(this.srcDom.value.indexOf(" ")==-1){
			this.srcDom.value = "select * from " + this.srcDom.value
		}*/
		var tmp = 0;
		var query = Query.value;
		var xy = DHC.getTextAreaPlace(Query);
        var refindex = 0;
        tmp = query.lastIndexOf("->",xy[0]-2);
        if(tmp>-1) refindex = tmp+2
        index = SqlParser.getLastWordIndex(query,xy[0])+1;
    	index = Math.max(index,refindex);
		var pre = query.substr(0, index);
		var post = query.substr(xy[1]);		
		var selectedValue = selectedDom.value;		
		if (tableSet["SQLUser"] && tableSet["SQLUser"].indexOf(selectedValue)>-1) {
			if(query.substr(index-1,index)!="."){
				selectedValue = "SQLUser."+selectedValue; //SQLUser中的表在没有写Schame时自动带上SQLUser.的前缀				
			}
		};
		var selectedValueLen = selectedValue.length;
		this.srcDom.value = pre + selectedValue + post;
		var mouseIndex = parseInt(index)+parseInt(selectedValueLen);
		DHC.setTextAreaPlace(Query,mouseIndex,mouseIndex);
	}
	tip.SelectedEnterCallBack = function(selectedDom){		
		var tmp = 0;
		var query = Query.value;
		var xy = DHC.getTextAreaPlace(Query);
        	var pre = query.substr(0,xy[0]);
		var post = query.substr(xy[1]);		
		var selectedValue = selectedDom.value;		
		if (selectedValue){ 
			/*selectedValue前部相同去除*/
			/*选中值前部与query框pre最后部对比*/
			var myPreUP = pre.toUpperCase();
			var repeatLen = 0;
			var mySelectedValueUP = selectedValue.toUpperCase();
			for (var plen=selectedValue.length; plen>0; plen--){
				var lastInd = myPreUP.lastIndexOf(mySelectedValueUP.slice(0,plen));
				if (lastInd>-1 && (xy[0]-lastInd==plen)){
					repeatLen = plen;
					break;
				}
			}
			//if (repeatLen>0) selectedValue = selectedValue.slice(repeatLen);
		}
		var selectedValueLen = selectedValue.length;
		this.srcDom.value = pre.slice(0,xy[0]-repeatLen) + selectedValue + post;
		var mouseIndex = xy[0]+parseInt(selectedValueLen);
		DHC.setTextAreaPlace(Query,mouseIndex,mouseIndex);
	}	
	textTip = new DHC.TextTip();
	if(!DHC.isIE) textTip.on();
	DHC.addEventListener(Query,"keydown",queryKeyDownHandler);
	DHC.addEventListener(Query,"keyup",queryKeyUpHandler);
	DHC.addEventListener(Query,"mouseover",function(){
		 document.getElementById("Query-wrap").className='divMouseFocus';
	});
	DHC.addEventListener(Query,"mouseout",function(){
		 document.getElementById("Query-wrap").className='divMouseOut';
	})
	 
	var resultSetTable = document.getElementById("resultSetTable");
	DHC.addEventListener(resultSetTable,"click",tableClickRowHandler);
	DHC.addEventListener(resultSetTable,"dblclick",tabledblClickRowHandler);	
	//consoleDivObj = document.getElementById("consoleDiv");
	//consoleTblObj = document.getElementById("consoleTbl");
	//consoleBtn = document.getElementById("consoleBtn");	
	//DHC.addEventListener(consoleBtn,"click",consoleBtnClickHandler);
	//scroll({id:'consoleDiv',f:1});
	/*DHC.Ajax.req({
        url: "dhctt.request.csp", 
        data: {SQLStatement:"", act:"getSQLStatement"}, 
        type:"POST",         
        async: true,
        dataType: "json",
        success: function handler(obj){  
            tableSet = obj.data;            
        }
    })*/
	/*DHC.Ajax.req({
		url: "dhctt.request.csp", 
		data: {schema: "SQLUser", table: "", act:"getAllTable"}, 
		type:"GET", 		
		async: true,
		dataType: "json",
		success: function handler(obj){													
			tableSet[obj.schema] = obj.data;			
		}
	})	*/
});