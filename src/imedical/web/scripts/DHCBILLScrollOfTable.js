/**
* fileName:DHCBILLScrollOfTable.js
* author:  Lid
* date:    2010-08-22
* function:实现组件中Table的滚动条功能
* version: v1.0
* notice:  为了统一版本，如需修改该JS文件,请先通知李东(010-62662360),谢谢！！
*/

DHCBILL.ns("DHCBILL.ScrollOfTable"); 
//表格滚动条
(function(){
    var WriteCSS=function(){
			///引入默认样式
			//document.write('<style type="text/css"> .tableScroll{overflow-x:scroll;overflow-y:scroll;}</style>'); //滚动条样式
			//document.write('<style type="text/css"> .tableScroll{overflow:auto}</style>'); //滚动条样式
			//document.write('<style type="text/css"> .fixedHeaderTr{position:relative;top:expression(this.offsetParent.scrollTop);backgroup:blue;}</style>'); //列头样式，使列头不随滚动条移动
			document.write('<link type="text/css" rel="stylesheet" href="../scripts/dhcbill.css" />'); //列头样式，使列头不随滚动条移动
			document.body.style.overflow="hidden"; //隐藏窗口滚动条
	};
	//tableName,tableClassName,tblHeadClassName,divWidth,divHeight,ScrollPosition
	var SetScrollForTable=function(){
			WriteCSS();  //写滚动条CSS样式
			//获取组件名
			var tableName=(window.document.getElementsByTagName("form")[0].id).slice(1);
			//根据组件名获取配置信息
			var rtn=tkMakeServerCall("web.DHCBILLLLibraryLogic","GetScrollInfo",tableName,session['LOGON.GROUPID'],session['LOGON.USERID']);
			var aTmp=rtn.split("^");
			var tableClassName=aTmp[1];
			var tblHeadClassName=aTmp[2];			
			var divWidth=aTmp[3];
			var divHeight=aTmp[4];
			var ScrollPosition=aTmp[5];
			var colLockFlag=aTmp[6]
			var tblName="t"+tableName;
			var formName="f"+tableName;
			if(typeof(tableClassName)==="undefined"||tableClassName===""){tableClassName="tableScroll";}       ///使用默认样式
			if(typeof(tblHeadClassName)==="undefined"||tblHeadClassName===""){tblHeadClassName="fixedHeaderTr";}
			//if(typeof(divWidth)==="undefined"||divWidth===""){divWidth="100%";}
			//if(typeof(divHeight)==="undefined"||divHeight===""){divHeight="450";}
			if(typeof(ScrollPosition)==="undefined"||ScrollPosition===""){ScrollPosition=""}
			///判断数据列表是否在一个Div中，如果在则记录这个div的位置
			var divIndex=-1; 
			var objComponent= document.getElementById(formName);
			var objdiv = objComponent.getElementsByTagName("DIV");
			for (var i=0;i<objdiv.length;i++){
				var objdivtable=objdiv[i].getElementsByTagName("table")
				for(var j=0;j<objdivtable.length;j++){
					if(objdivtable[j].id==tblName){
						divIndex=i;
						break;	
					}
				}
			}
			if(divIndex==-1){
				 ///数据列表在div中
				 var tmp; 
				 //设置table滚动样式
				 var fobj=document.getElementById(tblName).parentNode;
				 if(fobj){
					tmp=fobj.cloneNode(true);
					fobj.innerHTML="";
				 }	
				 var obj= document.createElement("Div");
				 obj.id="tblDiv"
				 obj.className=tableClassName;  // width:100%;height:400;
				 obj.dir=ScrollPosition;      //RTL:左边，,"":右边
				 fobj.appendChild(obj)
				 document.getElementById('tblDiv').appendChild(tmp)
				 var divTop=DHCBILL.GetElCoordinate(obj).top;
				 //var screenHeight=screen.availHeight;
				 var screenHeight=document.body.offsetHeight
				 if(typeof(divHeight)==="undefined"||divHeight===""||divHeight===" "){divHeight=screenHeight-divTop;}  //如果div高度未定义则自动计算(因考虑屏幕上下占位问题，多减100px)
				 var aObj=document.getElementsByTagName("SMALL")
				 if(aObj&&aObj.length>0){
			        divHeight=divHeight-30
		         }
				 obj.style.height=divHeight; 
				 var divLeft=DHCBILL.GetElCoordinate(obj).left;
				 //var screenWidth=screen.availWidth;
				 var screenWidth=document.body.offsetWidth;
				 if(typeof(divWidth)==="undefined"||divWidth===""||divWidth===" "){divWidth=screenWidth-divLeft}
				 obj.style.width=divWidth;
  				 var tbl=document.getElementById(tblName);
				 try {if (tbl) tbl.onclick=SelectRow;} catch(e) {}
				 try {if (tbl) tbl.onKeyPress=SelectRow;} catch(e) {}
				 try {if (tbl) tbl.className='tblListSelect';} catch(e) {}

				 tmp="";		
			}else{
				///数据列表在div中
				var fObj= document.getElementById(formName);
				var divObj= fObj.getElementsByTagName("div")[divIndex];
				divObj.className=tableClassName;	
				 var divTop=DHCBILL.GetElCoordinate(divObj).top;
				 //var screenHeight=screen.availHeight;
				 var screenHeight=document.body.offsetHeight
				 if(typeof(divHeight)==="undefined"||divHeight===""||divHeight===" "){divHeight=screenHeight-divTop;}
				 var aObj=document.getElementsByTagName("SMALL")
				 if(aObj&&aObj.length>0){
			        divHeight=divHeight-30
		         }
				divObj.style.height=divHeight;
				var divLeft=DHCBILL.GetElCoordinate(divObj).left;
				 //var screenWidth=screen.availWidth;
				var screenWidth=document.body.offsetWidth;	
				if(typeof(divWidth)==="undefined"||divWidth===""||divWidth===" "){divWidth=screenWidth-divLeft}
				divObj.style.width=divWidth;
				divObj.dir=ScrollPosition;      //RTL:左边，,"":右边
			}
			//设置表头(tHead)不滚动(只对表头是THead的标签起作用)
			var tobj=document.getElementById(tblName);
			if(tobj){
				var obj=tobj.tHead.getElementsByTagName("tr");
				//obj[0].className=tblHeadClassName
				for(var i=0;i<obj[0].childNodes.length;i++){
					var oTh=obj[0].getElementsByTagName("th")[i];
					if(!oTh)continue;
					oTh.className="VLocked";  // "VLocked";
					if(colLockFlag==="true"){
						//设置鼠标悬浮提示信息
						if(oTh.className==="Locked"){
								oTh.title="解锁";
							}else{
								oTh.title="锁定";
						}
						//注册th点击事件
						oTh.onmousedown=function(e){
							var flag=window.event.button;  //获取鼠标按键值
							var colIndex=this.cellIndex+1;  //获取列索引
							//alert(this.parentElement.rowIndex+":"+ (this.cellIndex+1))
							if(this.className==="Locked"){
								unlocked(tobj,colIndex,flag,this);
							}else{
								locked(tobj,colIndex,flag,this);
							}
						};
			            oTh.oncontextmenu=function(e){return false}; //禁用表头的右键菜单	
					}	
				}
			}
	}
	//锁定
	function locked(tObj,colIndex,flag,t){
		var aTrObj=tObj.getElementsByTagName("tr");
		if(!aTrObj)return;
		for(var i=0;i<aTrObj.length;i++){
			var oTr=aTrObj[i];
			for(var j=0;j<=colIndex;j++){
				if(i===0){
					oTr.getElementsByTagName("th")[j].className="Locked";
					oTr.getElementsByTagName("th")[j].title="解锁";
				}else{
					oTr.childNodes[j].removeAttribute('className');
					oTr.childNodes[j].setAttribute('className','HLocked');
				}
			}
		}
	}
	//解锁
	function  unlocked(tObj,colIndex,flag,t){
		var lockedObj=DHCBILL.getElementsByClassName("Locked","th");
		if(!lockedObj)return;
		var len=lockedObj.length;
		if(len<=0)return;
	    var aTrObj=tObj.getElementsByTagName("tr");
		if(!aTrObj)return;
		if(flag===2){
			var bConfirm=window.confirm("是否全部解锁?");
			if(!bConfirm)return;
			colIndex=0;
		}
		for(var i=0;i<aTrObj.length;i++){
			var oTr=aTrObj[i];
			for(var j=colIndex;j<=len;j++){
				if(i===0){
					oTr.getElementsByTagName("th")[j].className="VLocked";
					oTr.getElementsByTagName("th")[j].title="锁定";
				}else{
					oTr.childNodes[j].removeAttribute('className');
					oTr.childNodes[j].setAttribute('className','UNHlocked');
				}
			}
		}
	}
	var initTableHead=function(){
		var tableName=(window.document.getElementsByTagName("form")[0].id).slice(1);
		var tobj=document.getElementById("t"+tableName);
		if(tobj){
			var obj=tobj.tHead.getElementsByTagName("th");
		    //tobj.tHead.style.cursor='hand';
			for(var i=0;i<obj.length;i++){
				//设置鼠标悬浮提示信息
				if(obj[i].className==="Locked"){
						obj[i].title="解锁";
					}else{
						obj[i].title="锁定";
				}
				//注册th点击事件
				obj[i].onmousedown=function(e){
					var flag=window.event.button;  //获取鼠标按键值
					var colIndex=this.cellIndex+1;  //获取列索引
					//alert(this.parentElement.rowIndex+":"+ (this.cellIndex+1))
					if(this.className==="Locked"){
						unlocked(tobj,colIndex,flag,this);
					}else{
						locked(tobj,colIndex,flag,this);
					}
				};
	            obj[i].oncontextmenu=function(e){return false}; //禁用表头的右键菜单
			}
		}	
	}
	DHCBILL.apply(DHCBILL.ScrollOfTable,{
		autoRunSetScrollOfTable:function(){
			SetScrollForTable();
		}()
	})
})();