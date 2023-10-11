/*
 * Ext JS Library 3.1.0
 * Copyright(c) 2009-2010 DHCC
 */
 /**
* @param {String} url 链接路径 如: https://127.0.0.1/dthealth/web/csp/test.csp?EpisodeId=1&UserId=1
* @param {Object} obj 直接对象 如: {"EpisodeId":2,OrderId:"2||1"}
* @return {String} 组合后的url串 如:https://127.0.0.1/dthealth/web/csp/test.csp?EpisodeId=2&UserId=1&OrderId=2||1
*/
function rewriteUrl(url, obj){
	var reg,flag, indexFlag = false;
	var indexFlag = (url.indexOf("?")==-1);
	if(indexFlag){
		url += "?";	
	}
	for (var i in obj){	
		if(obj.hasOwnProperty(i)){
			flag = false; 	
			if(!indexFlag){
				reg =  new RegExp(i+"=(.*?)(?=$|&)","g");
				url = url.replace(reg, function(m1){
					flag = true;
					return i+"="+obj[i];
				});
			}
			if(!flag){
				url  +=   "&" + i + "=" + obj[i];
			}
		}
	}
	return url;	
}
// refresh patient bar
var refreshBar = function (){
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value; //DHCDocMainView.PatientID;
		var adm = frm.EpisodeID.value; //DHCDocMainView.EpisodeID;
		var mradm = frm.mradm.value;
		if (adm > 0 ){
			if(parent && parent.frames[0] && parent.frames[0].location.href.indexOf("PAPerson.Banner")>-1){
				parent.frames[0].location.href = rewriteUrl("websys.default.csp?WEBSYS.TCOMPONENT=PAPerson.Banner",{EpisodeID:adm,PatientID:papmi,mradm:mradm});
			}
		}
	}
};

Ext.onReady(function(){
   //var charsJsonstr = tkMakeServerCall("ext.epr.Chart","ShowChartJson","1");
	var chartitems=Ext.util.JSON.decode(chartJSONStr);
	tabsChart = new Ext.TabPanel({
	//var tabsChart = new Ext.ux.VerticalTabPanel({
		id:"EPRChartBook",
        //renderTo: document.body,
        activeTab: 0,
        //width:600,
        //Height:600,
        //autoWidth:true,
        //autoHeight:true,
        //plain:true,
        region:'center',
        //defaults:{autoScroll: true}, //wanghc 2015-10-30 ie11内chart会有二个scroll
        enableTabScroll:true,
        tabPosition:'top',
        //items:[chartitems]
        listeners: {
			beforetabchange:function(tabPnl,newTab,tab){
				var frm = dhcsys_getmenuform();
				if (frm.DoingSth){
					 var doingSthDesc = frm.DoingSth.value;
					 if (doingSthDesc!=""){
						 //var sthWin = new Ext.Window({closable:true, modal:true, layout:'fit', width:200, html:doingSthDesc,title:'提示',height:80}).show().setPosition(800,50);	
						 //setTimeout("sthWin.hide()",1500);
						 //Ext.Msg.alert('提示', doingSthDesc);
						 alert(doingSthDesc);
						 return false;
					 }
				}
				if (typeof(tab) == 'undefined' || typeof(tab.id) == 'undefined') return true;
				
				var frame = window.frames["dataframe"+tab.id];		
				if ( frame ){
					var chartOnBlur = "";
					if ("function" === typeof frame.chartOnBlur){
						chartOnBlur = frame.chartOnBlur; 
					}else if (frame.contentWindow && "function" === typeof frame.contentWindow.chartOnBlur){
						chartOnBlur = frame.contentWindow.chartOnBlur;
					}
					if(chartOnBlur) {
						//如果返回非true,不切换Chart
						if (!chartOnBlur()){return false;};	
				    }			
				}

				if (typeof(newTab) == 'undefined' || typeof(newTab.id) == 'undefined') return true;
				
				var newTabframe = window.frames["dataframe"+newTab.id];		
				if ( newTabframe ){
					var chartOnFocus = "";
				
					if ("function" === typeof newTabframe.chartOnFocus){
						chartOnFocus = newTabframe.chartOnFocus; 
					}else if (newTabframe.contentWindow && "function" === typeof newTabframe.contentWindow.chartOnFocus){
						chartOnFocus = newTabframe.contentWindow.chartOnFocus;
					}
					if(chartOnFocus) {
						var frm = dhcsys_getmenuform();
						var papmi="",adm="",mradm="";
						if (frm) {
							papmi = frm.PatientID.value;
							adm = frm.EpisodeID.value; 
							mradm = frm.mradm.value; 
						}
					    chartOnFocus({papmi: papmi, adm: adm, mradm: mradm});	
					}			
				}
				return true;					
			}	    
	    }
    });
	
	for (i=0;i<chartitems.length;i++){
		var objitem=chartitems[i];
		//alert(+objitem.id+":"+objitem.autoLoad.url);
		obj=tabsChart.add({
			id:"TAB"+objitem.id,
			title:objitem.title,
			iconCls: 'tabs',
			cls:objitem.autoLoad.url,
			chartCls:objitem.autoLoad.url,
			csprefresh:objitem.csprefresh,
			listeners:{	
    			activate:function(tab){
	    			//debugger;
	    			var frm = dhcsys_getmenuform();
					var papmi="",adm="",mradm="";
					if (frm) {
						papmi = frm.PatientID.value;
						adm = frm.EpisodeID.value; 
						mradm = frm.mradm.value;
						if (papmi=="" && adm!=""){
							var papmi = tkMakeServerCall("web.DHCDocMain","GetPatientId",adm);
							frm.PatientID.value = papmi;
						}
					}
	    			if (typeof tab.csprefresh!="undefined" && tab.csprefresh){
					    //两种方式都可以重新刷新页面 
					    // header---get paadmrowid
					    url = rewriteUrl(tab.chartCls,{EpisodeID:adm,PatientID:papmi,mradm:mradm})
        				window.frames["dataframe"+tab.id].location.href = url;        				
        				//window.frames["dataframe"+tab.id].location.reload(); 
        				//Ext.get("dataframe"+tab.id).dom.src=Ext.get("dataframe"+tab.id).dom.src;
	    			}else{
						var frame = window.frames["dataframe"+tab.id];		
						if ( frame ){
							var xhrRefresh="";
							if ("function" === typeof frame.xhrRefresh){
								xhrRefresh = frame.xhrRefresh; 
							}else if (frame.contentWindow && "function" === typeof frame.contentWindow.xhrRefresh){
								xhrRefresh = frame.contentWindow.xhrRefresh
							}
							if(xhrRefresh) {xhrRefresh({papmi: papmi, adm: adm, mradm: mradm});	}			
						}
	    			}
    			}	
    		},
			html:"<iframe id='dataframeTAB"+objitem.id+"' name='dataframe"+objitem.id+"' height='100%' width='100%' src='" + objitem.autoLoad.url + "'/>"
			//closable:true
		})
		//obj.show();
	}
	tabsChart.setActiveTab('TAB'+chartitems[0].id);
	MainViewport = new Ext.Viewport({
		id : 'MainViewport'
		,layout : 'border'
		,items:[tabsChart]
	});
	parent.checkModifiedBeforeUnload = (function(){
		return function(){
			var tab = tabsChart.getActiveTab();
			var frame = window.frames["dataframe"+tab.id];
			if (frame && frame.checkModifiedBeforeUnload){
				return frame.checkModifiedBeforeUnload();
			}
			return false;
		}
	})()
});
/*wanghc 2020-04-09  7.0-> 8.2*/
function switchTabByEMR(tabName,cfg){
	if (tabName==""){alert("请传入要打开的页签名!");}
	alert(tabName+","+","+cfg);
	var tabItemsJson = Ext.util.JSON.decode(chartJSONStr);
	Ext.each(tabItemsJson,function(r,ind){
		if (r.title.trim()==tabName.trim()){
			//setActiveTab(ind);
			tabsChart.setActiveTab('TAB'+r.id);			
			return ;
		}
	}); 
	return ;
 }
 /*wanghc 2016 Chart间相互调用方法,parent.invokeChartFun("电子病历", "funName", "params1", "params2", ...)*/
function invokeChartFun(tabName,funName){
	var tabItemsJson = Ext.util.JSON.decode(chartJSONStr);
	Ext.each(tabItemsJson,function(r,ind){
		if (r.title.trim()==tabName.trim()){
			var newTabframe = window.frames["dataframe"+r.id];
			if ( newTabframe ){
				var fun = "";
				if ("function" === typeof newTabframe[funName]){
					fun = newTabframe[funName]; 
				}else if (newTabframe.contentWindow && "function" === typeof newTabframe.contentWindow[funName]){
					fun = newTabframe.contentWindow[funName];
				}
				if(fun) {
					var args=[],j=0;
					for (var i=2; i<invokeChartFun.arguments.length; i++) {
						args[j++]=invokeChartFun.arguments[i];
					}
					fun.apply(newTabframe,args);
				}			
			}
			return ;
		}
	}); 
	return ;
}