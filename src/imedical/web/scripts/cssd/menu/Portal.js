var init = function () {
	var panels = [
		{id:'p1',title:'待办列表',height:300,collapsible:true,closable:true,content:"<div><ul id='vexp' style='padding-left:20px'></ul></div>"},
		{id:'p2',title:'过期提醒',height:240,collapsible:true,closable:true,content:"<div><ul id='todolist' style='padding-left:20px'></ul></div>"}
	    
		/**
		{id:'p3',title:'厂商资质过期提醒',height:300,collapsible:true,closable:true,content:"<div><ul id='mexp' style='padding-left:20px'></ul></div>"},
		{id:'p7',title:'注册证过期提醒',height:300,collapsible:true,closable:true,content:"<div><ul id='cert' style='padding-left:20px'></ul></div>"},
		{id:'p4',title:'分类数量占比统计',height:550,collapsible:true,closable:true,content:"<div><div id='chartScgQty' style='width:700px;height:500px;'></div></div>"},
		{id:'p5',title:'分类金额占比统计',height:550,collapsible:true,closable:true,content:"<div><div id='chartScgAmt' style='width:700px;height:500px;'></div></div>"},
		{id:'p6',title:'供应链云平台',height:280,collapsible:true,closable:true,content:"<div><div style='width:550px;height:500px;'></div></div>"} */
	];
	function getPanelOptions(id){
		for(var i=0; i<panels.length; i++){
			if (panels[i].id == id){
				return panels[i];
			}
		}
		return undefined;
	}
	function getPortalState(){
		var aa = [];
		for(var columnIndex=0; columnIndex<2; columnIndex++){
			var cc = [];
			var panels = $('#pp').portal('getPanels', columnIndex);
			for(var i=0; i<panels.length; i++){
				cc.push(panels[i].attr('id'));
			}
				aa.push(cc.join(','));
			}
		return aa.join(':');
	}
	function addPanels(portalState){
		var columns = portalState.split(':');
		for(var columnIndex=0; columnIndex<columns.length; columnIndex++){
			var cc = columns[columnIndex].split(',');
			for(var j=0; j<cc.length; j++){
				var options = getPanelOptions(cc[j]);
				if (options){
					var p = $('<div/>').attr('id',options.id).appendTo('body');
					p.panel(options);
					$('#pp').portal('add',{
					panel:p,
					columnIndex:columnIndex
					});
				}
			}
		}
	}
	
	$('#pp').portal({
		onStateChange:function(){
			var state = getPortalState();
	}
	});
	var state ="";
	if (!state){
	state = 'p1,p2,p3,p7:p4,p5,p6'; // the default portal state
	}
	addPanels(state);
	$('#pp').portal('resize');
	
	function fillPanel(){
		$.cm({
			ClassName: 'web.CSSDHUI.Common.TipsWin',
			MethodName: 'GetTips',
			Params: JSON.stringify(sessionObj),
			wantreturnval:0
		},function(jsonData){
			if(jsonData.doccount>0){
				 $.tmpl(tmpld,jsonData.doc).appendTo( "#todolist" );
				 $('#todolist').on('click','li',function(){
				 	var url=$(this).attr("url");
				    var tabTitle=$(this).attr("title");
				    window.parent.addTab(tabTitle, url);
				})
			}
			if(jsonData.docapplycount>0){
				 $.tmpl(tmpapplyld,jsonData.docapply).appendTo( "#vexp" );
				 $('#vexp').on('click','li',function(){
				 	var url=$(this).attr("url");
				    var tabTitle=$(this).attr("title");
				    window.parent.addTab(tabTitle, url);
				})
			}
			/**
			if(jsonData.mexpcount>0){
				 $.tmpl(tmplv,jsonData.mexp).appendTo( "#mexp" );
			}
			if(jsonData.incicert){
				 $.tmpl(tmplc,jsonData.incicert).appendTo( "#cert" );
			}		 */	
						
		});
	}
	fillPanel();

	var tmpld = "<li url=${NodeUrl} title=${NodeCaption}><a href='#' style='font-size:16px;font-weight:bold;'>${Info}</a></li>";
	var tmpapplyld = "<li url=${NodeUrl} title=${NodeCaption}><a href='#' style='font-size:16px;font-weight:bold;'>${Info}</a></li>";
	/**
	var tmplv = "<li id=${Id}><dl><dt style='font-size:16px;font-weight:bold;'>${Name}</dt><dd>${Info}</dd>"
				+"<table border=1 cellspacing=0>{{each(i,d) Detail}}"
				+"<tr>"
       			+"<td>${i+1}:{{= d.Type}}</td>"
       			+"<td>{{= d.Date}}</td>"
       			+"</tr>"
				+"{{/each}}</table></dl></li>";
	var tmplc = "<li id=${Id}><dl><dt style='font-weight:bold;'>${Name}</dt><dd>${Info}${Detail}</dd></dl></li>";	
	**/
	$.cm({
		ClassName:"web.CSSDHUI.Charts",
		MethodName:"GetScgChildNode",
		NodeId:"AllSCG",
		StrParam: gLocId+"^"+gUserId+"^^^"+"Amt",
		Type:"M"
	},function(jsonData){
		sunburstAmt(jsonData);
	});
function sunburstAmt(data){
   //指定图标的配置和数据
	var option = {
		tooltip:{
			 trigger: 'item'
		},
		series: {
	        type: 'sunburst',
	        center: ['50%', '50%'],
	        radius: [10, '90%'],
	        data:data,
	        levels: [{
	        },{
	            r0: 0,
	            r: 125
	        }, {
	            r0: 125,
	            r: 225
       		 }, {
	            r0: 225,
	            r: 300
		       }]	        
	        }
	};
    //初始化echarts实例
    var Chart = echarts.init(document.getElementById('chartScgAmt'));
    Chart.setOption(option);
	}
	$.cm({
		ClassName:"web.CSSDHUI.Charts",
		MethodName:"GetScgChildNode",
		NodeId:"AllSCG",
		StrParam: gLocId+"^"+gUserId+"^^^"+"Qty",
		Type:"M"
	},function(jsonData){
		sunburstQty(jsonData);
	});
function sunburstQty(data){
   //指定图标的配置和数据
	var option = {
		tooltip:{
			 trigger: 'item'
		},		
		series: {
	        type: 'sunburst',
	        center: ['50%', '50%'],
	        radius: [0, '90%'],
	        data:data,
	        levels: [{
	        },{
	            r0: 0,
	            r: 125
	        }, {
	            r0: 125,
	            r: 225
       		 }, {
	            r0: 225,
	            r: 300
		       }]
		}
	};
    //初始化echarts实例
    var Chart = echarts.init(document.getElementById('chartScgQty'));
    Chart.setOption(option);
	}
}
$(init);
