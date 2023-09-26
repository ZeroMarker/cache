/**
* fileName:DHCBILLPaginate.js
* author:  Lid
* date:    2010-08-22
* function:实现组件中Table的分页跳转功能
* version: v1.0
* notice:  为了统一版本，如需修改该JS,请先通知李东(010-62662360),谢谢！！
*/

DHCBILL.ns("DHCBILL.Paginate"); 

//分页功能
(function(){
	//私有函数
	//跳转页
	var aimPage=function(tableName,btnQueryName,compId,QueryInfo,pageCount){
				var currentPage=document.getElementById("curPage").value;
				if(currentPage<=0)currentPage=1;      //              
				if(currentPage>pageCount)currentPage=pageCount; //输入的跳转值大于总页数时，按总页数处理
				var aQueryInfo=QueryInfo.split("^");
				var paramInfo="";
				for(var i=2;i<aQueryInfo.length;i++){
					var paramName=aQueryInfo[i];
					//alert(paramName);
					var obj=document.getElementById(paramName);
					if(obj){
						var paramValue=document.getElementById(paramName).value;
						if(paramValue===""){
							paramValue=DHCBILL.GetHrefParam(window,paramName)	
						}
						if(paramValue==="")continue;
						if(paramInfo===""){
							paramInfo=paramName+"="+paramValue;
						}else{
							paramInfo=paramInfo+"&"+paramName+"="+paramValue;	
						}
					}
				}
				if(DHCBILL.isPositiveNumber(currentPage)){  //验证是否正整数
					currentPage=+currentPage-1	
				}else{
					return;	
				}
				//alert(btnQueryName!="");
				if(btnQueryName!=""){
					//alert(1+":"+btnQueryName)
					var str="websys.csp?TEVENT=d"+compId+"i"+btnQueryName+"&"+paramInfo+"&TPAGCNT="+currentPage+"&TSRT=0";	
				}else{
					//var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPInvDaily&stDate=07/04/2012&stTime=14:25:11&endDate=17/04/2012&endTime=17:21:11&handin=false&guser=639&hospDr=2&jkDr=&job=4404&CONTEXT=&TWKFL=&TWKFLI=&TPAGCNT=1&TSRT=0";
					var str="websys.default.csp?WEBSYS.TCOMPONENT="+tableName+"&"+paramInfo+"&CONTEXT=&TWKFL=&TWKFLI="+"&TPAGCNT="+currentPage+"&TSRT=0";	
				}
				//alert(str);
				window.location.href=str	
	}
	var PageCount_OnKeyUp=function(tableName,btnQueryName,compId,aQueryInfo,pageCount){
		 var e=window.event;
		 if(e.keyCode===13){
			 aimPage(tableName,btnQueryName,compId,aQueryInfo,pageCount);	 
		 }
		 if(!DHCBILL.isPositiveNumber(this.value)){
			this.focus();this.value="";return;
		 }else{
			 
		 }
	};
	var PageCount_OnKeyDown=function(){
		 if(!DHCBILL.isPositiveNumber(this.value)){
			this.focus();this.select();this.value="";return;
		 }else{
			 
		 }	
	}
	///到首页
	var firstPage=function(tableName,btnQueryName,compId,aQueryInfo,pageCount){
		aimPage(tableName,btnQueryName,compId,aQueryInfo,pageCount);
	};
	///尾页
	var lastPage=function(tableName,btnQueryName,compId,aQueryInfo,pageCount){
		aimPage(tableName,btnQueryName,compId,aQueryInfo,pageCount);
	};
	//鼠标移动事件
	var btnover=function(){
		this.style.color="red"	
	};
	var btnout=function(){
		this.style.color="blue"
	};
	//给HTML插入翻页元素
	var insertSepBtn=function(tblName){
		//获取组件名
		if(typeof(tblName)==="undefined"||tblName===""){
			tblName=(window.document.getElementsByTagName("form")[0].id).slice(1);
		}
		if(typeof(btnQueryName)==="undefined"||btnQueryName===""){
			btnQueryName="Find";
		}
		//获取Query信息
		var CHR2=String.fromCharCode(2);
		var rtn=tkMakeServerCall("web.DHCBILLLLibraryLogic","GetCompQueryInfo",tblName,session['LOGON.GROUPID'],session['LOGON.USERID']);
		var aTmp=rtn.split(CHR2);
		var compId=aTmp[0];  //组件Rowid
		var pageSize=aTmp[2]; //显示行数
		var aQueryInfo=aTmp[1];  //组件绑定的Query信息
		var btnQueryName=aTmp[3]
		//取Query查询的总行数(此处现通过修改Query获取，需要优化)
		var tblRows=DHCBILL.GetTableRows("t"+tblName);
		if(tblRows===0)return;
		//alert(PrtRowCnt);
		//if(PrtRowCnt=="0")return;
		//var totalCount=PrtRowCnt;
		var totalCount=document.getElementById("RecordSumz1").value;
		//alert(totalCount+"^"+pageSize);
		var pageCount=Math.ceil(+totalCount/+pageSize); //总页数
		var aObj=document.getElementsByTagName("SMALL")
		if(aObj&&aObj.length===0){
			return;
		}
		var smallObj=aObj[0];
		var parentObj=smallObj.parentNode; //取父节点对象
		var currentPage=smallObj.innerText;
		smallObj.innerText="";
		
		//首页
		var obj= document.createElement("img");
		obj.border="0";
		obj.id="pageFirst";
		//obj.src="../images/websys/page-first.gif";
		obj.src="../images/websys/pageprevend.gif";
		obj.onclick=function(){
			document.getElementById("curPage").value=1;
			firstPage.call(this,tblName,btnQueryName,compId,aQueryInfo,pageCount)	
		}
		if((parentObj.firstChild.nodeName==="IMG")&&(!document.getElementById("pageFirst"))){
			  parentObj.insertBefore(obj,parentObj.firstChild);    	
		}	
		//尾页
		var obj= document.createElement("img");
		obj.border="0";
		obj.id="pageEnd"
		//obj.src="../images/websys/page-last.gif";
		obj.src="../images/websys/pagenextend.gif";
		obj.onclick=function(){
			document.getElementById("curPage").value=pageCount;
			lastPage.call(this,tblName,btnQueryName,compId,aQueryInfo,pageCount)	
		}
		if(parentObj.lastChild.nodeName==="IMG"&&(!document.getElementById("pageEnd"))){
			 parentObj.appendChild(obj);    	
		}
		//跳转
		var fragObj=document.createDocumentFragment(); 
		var showStr="共 "+pageCount+" 页"
		var obj= document.createElement("input");
		obj.type="button"
		obj.value=showStr;
		fragObj.appendChild(obj);
		var obj= document.createElement("input");
		obj.type="text"
		obj.id="curPage"
		obj.name="curPage"
		obj.size="6"
		obj.value=currentPage;
		obj.onkeydown=PageCount_OnKeyDown;
		obj.onkeyup=function(){
			PageCount_OnKeyUp.call(this,tblName,btnQueryName,compId,aQueryInfo,pageCount);	
		};
		fragObj.appendChild(obj)
		var obj= document.createElement("input");
		obj.type="button"
		obj.id="aim"
		obj.name="aim"
		obj.style.color="blue"
		//obj.onclick=aimPage;
		obj.onclick=function(){
			aimPage.call(this,tblName,btnQueryName,compId,aQueryInfo,pageCount)	
		}
		obj.onmouseover=btnover;
		obj.onmouseout=btnout;
		obj.value="跳转"
		fragObj.appendChild(obj);
		smallObj.appendChild(fragObj);
	}
	DHCBILL.apply(DHCBILL.Paginate,{
		autoRunPaginate:function(tblName){
			insertSepBtn(tblName)
		}()
	});
})();