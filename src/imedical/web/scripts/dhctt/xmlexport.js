var tip,cnObj,timeoutId;
var TIMER = 1000;
var getTableNameListCallback = function (json){
	tip.updateSelect(json);	
	tip.show();
}
var getComponentNameList = function (oldCnValue){
	if(oldCnValue === cnObj.value){						
		var data = {
			componentName: oldCnValue, 
			act:'getComponentNameList'
		};
		//$.ajax({url:"../csp/dhctt.request.csp",data: data, dataType: "json",success: getTableNameListCallback });	//Jquery--off			
		DHC.Ajax.req({url: "dhctt.request.csp",dataType: "json",success: getTableNameListCallback, data: data});
		clearTimeout(timeoutId);
	}
	if(tip) tip.show();		
	return;
}
var componentNameKeyUpHandler = function (t){
	var code = DHC.getKeyCode(t);	
	if((code >= 65 && code <= 90) || (code >= 97 && code <= 122) || code === 8){	//A-Z a-z backspace				
		var cnvalue = cnObj.value.replace (/"/g,"").replace(/,/g,"");	
		if(cnvalue === "") {
			tip.updateSelect({});
			tip.hide();
			return ;
		}
		timeoutId = setTimeout("getComponentNameList(\""+cnvalue+"\")",TIMER);
		// getTableNameListCallback($.ajax({url:"../csp/dhctt.request.csp", async: false,data: data, dataType: "json"}).responseText);
	}else if(code === 40){	//向下键头
		if(tip.isShow){
			tip.select.focus();
			tip.select.selectedIndex = 0;
		}else{
			tip.show();
		}
	}else if(code === 13){
		//回车旿查找
		tip.hide();						
		//DHC.fireEvent("find","click");
	}
}
DHC.onReady(function (){
	tip = new DHC.Tip();	
	cnObj = document.getElementById("componentName");		
	var tnwidth = cnObj.offsetWidth + "px";	   	
	tip.renderTo(cnObj);
	tip.addSelect({},{
		style: {width: tnwidth},
		size: 12
	});		
	DHC.addEventListener(cnObj,"keyup", componentNameKeyUpHandler);
	//DHC.addEventListener(ntObj,"blur", tableNameBlurHandler);
	//DHC.addEventListener(ntObj,"focus", tableNameFocusHandler);
});