/**
* fileName:DHCBILLSortTable.js
* author:  Lid
* date:    2010-08-22
* function:实现组件中Table的列排序功能，以解决Trakcare列排序时行数的限制。(注:本JS只实现了客户端单列排序)
* version: v1.0
* notice:  为了统一版本，如需修改该JS文件,请先通知李东(010-62662360),谢谢！！
*/

DHCBILL.ns("DHCBILL.SortOfTable");

(function(){
    var arrowUp="";
	var arrowDown="";  //排序图标
	var sortFlag=true;       //排序标记
	var tableName="";     
	 ///生成排序图标
	var initICO=function (){
		arrowUp = document.createElement("SPAN");
		arrowUp.innerHTML	= "5";
		arrowUp.style.cssText 	= "PADDING-RIGHT: 0px; MARGIN-TOP: -3px; PADDING-LEFT: 0px; FONT-SIZE: 12px; MARGIN-BOTTOM: 4px; PADDING-BOTTOM: 2px; OVERFLOW: hidden; WIDTH: 12px; COLOR: red; PADDING-TOP: 0px; FONT-FAMILY: webdings; HEIGHT: 14px";
		arrowDown = document.createElement("SPAN");
		arrowDown.innerHTML	= "6";
		arrowDown.style.cssText = "PADDING-RIGHT: 0px; MARGIN-TOP: -3px; PADDING-LEFT: 0px; FONT-SIZE: 12px; MARGIN-BOTTOM: 4px; PADDING-BOTTOM: 2px; OVERFLOW: hidden; WIDTH: 12px; COLOR: red; PADDING-TOP: 0px; FONT-FAMILY: webdings; HEIGHT: 14px";
	};
	var ieOrFireFox=function(ob)   {   
		if (ob.textContent != null)   
		return ob.textContent;   
		var s = ob.innerText;   
		return s.substring(0, s.length);   
	};   
	///排序 tableId: 表的id,iCol:第几列 sortColHeader:第几列   
	var sortAble=function(tableId,iCol,sortColHeader) {  
		var table = document.getElementById(tableId);   
		var tbody = table.tBodies[0];   
		var colRows = tbody.rows;   
		var aTrs = new Array;   
			 //将将得到的列放入数组?备用   
		for (var i=0; i < colRows.length; i++) {   
			aTrs[i] = colRows[i];   
		}   
		///删除排序图标                     
		if(table.sortCol!=null){
			with(table.rows[0].cells[table.sortCol])
				removeChild(lastChild);
		}
		//判断上一次排列的列和现在需要排列的是否同一个?  
		if (table.sortCol == iCol) {   
			//添加排序图标
			sortFlag=!sortFlag;
			with(table.rows[0].cells[iCol])
				appendChild(sortFlag?arrowUp:arrowDown); 
			aTrs.reverse();
		   
		} else {   
			//如果不是同一列?使用数组的sort方法?传进排序函数   
			aTrs.sort(compareEle(iCol, sortColHeader));   
			 //添加排序图标
			sortFlag=true;
			with(table.rows[0].cells[iCol])
				appendChild(sortFlag?arrowUp:arrowDown); 
		}          
		var oFragment = document.createDocumentFragment();                
		for (var i=0; i < aTrs.length; i++) {   
			oFragment.appendChild(aTrs[i]);   
		}                   
		tbody.appendChild(oFragment);   
		//记录最后一次排序的列索引   
		table.sortCol = iCol;   
	};			
	///排序函数?iCol表示列索引?sortColHeader表示该列的数据类型   
	var compareEle=function(iCol, sortColHeader) {   
		return  function (oTR1, oTR2) {   
			var vValue1 = convert(ieOrFireFox(oTR1.cells[iCol]), sortColHeader);   
			var vValue2 = convert(ieOrFireFox(oTR2.cells[iCol]), sortColHeader);   
			if (vValue1 < vValue2) {   
				return -1;   
			} else if (vValue1 > vValue2) {   
				return 1;   
			} else {   
				return 0;   
			}   
		   };   
	}; 
	///将列的类型转化成相应的可以排列的数据类型   
	///此函数根据不同组件需要修改.
	var convert=function (sValue, sortColHeader) {  
		if(DHCBILL.checkDate(sValue)){  //日期验证，支付“yyyy-mm-dd hh:mm:ss“格式
			sValue=DHCBILL.trim(sValue)
			if((sValue.indexOf("-")!==-1)&&(sValue.indexOf(":")!==-1)){   //yyyy-mm-dd hh:mm:ss
				var tmpDate=DHCBILL.trim(sValue.split(" ")[0].split("-"));
				var tmpTime=DHCBILL.trim(sValue.split(" ")[1].split(":"));
				var dateTime=new Date(tmpDate[0],tmpDate[1],tmpDate[2],tmpTime[0],tmpTime[1],tmpTime[2]);
				return dateTime.getTime();
			}else if((sValue.indexOf("-")!==-1)&&(sValue.indexOf(":")===-1)){ //yyyy-mm-dd
				var date=sValue.split('-'); //转成成数组，分别为年，月，日，下同
				var rtn = date[0]+"/" + date[1]+ "/" + date[2];
				return rtn;
			}else if((sValue.indexOf(":")!==-1)&&(sValue.indexOf("-")===-1)){ //hh:mm:ss
				var tmpTime=sValue.split(":");
				return (new Date("","","",tmpTime[0],tmpTime[1],tmpTime[2])).getTime();
			}else{
				return 0;
			}
		}else if(DHCBILL.isString(sValue)){
			return parseFloat(sValue);
		}else if(DHCBILL.isNumber(sValue)){
			return sValue.toString();
		}else{
			return 0;
		}
	};
	DHCBILL.apply(DHCBILL.SortOfTable,{
		SortOfTable:function(){
			initICO();              //生成排序图标,注意此函数的位置.
		    if(!window.document.getElementsByTagName("form"))return;
		    tableName=(window.document.getElementsByTagName("form")[0].name).slice(1);
			var tableid="t"+tableName;
			var rowObj=document.getElementById(tableid).rows;
			var rowNum=rowObj[0].cells.length;
			for(i=1;i<rowNum;i++){
			   rowObj[0].cells[i].onclick=function(){ sortAble(tableid,this.cellIndex+1,this.childNodes[0].nodeValue)}
			}
		}()
	})
	
})() 
	
