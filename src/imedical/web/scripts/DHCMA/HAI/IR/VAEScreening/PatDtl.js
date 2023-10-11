//页面Gui
function InitPatDtl(obj){
	obj.pindex ='';
	obj.rindex = '';
	obj.EpisodeID = '';
	obj.AdmDate = '';
	obj.DischDate = '';
	obj.ScreenData = '';
	obj.RstID = '';
	//加载病人信息
	obj.BuildPatIfo = function(pindex,rindex,objAdm,flg) {   //flg=1，科室汇总
		var htmlStr='';
		var htmlMsg='';
		obj.EpisodeID = objAdm.EpisodeID;
		var EpisodeID = objAdm.EpisodeID;
		obj.pindex = pindex;
		obj.rindex = rindex;
		
		if (!EpisodeID) return;
		// 1.病人基本信息
		htmlStr ='<div id=divPatInfo'+EpisodeID+' class="panel-heading">'
				+ '	<ul class="list-inline">'
				+ '		<li>'
				+ '			<span id="txtSuspendDesc' + EpisodeID + '" style="font-weight:bold;font-size:120%;">'+objAdm.SuspendDesc+'</span>'
				+ '		</li>'
				+ 		((objAdm.SuspendDesc != '') ? '<li class="middle-line">|</li>':'')
				+ '		<li>'+objAdm.PatName+' '+objAdm.PapmiNo+'</li>'
				+ '		<li class="middle-line">|</li>'
				+ '		<li>' + ((objAdm.CurrBed != '') ? objAdm.CurrBed : '空床') + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.Sex + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.Age + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + ((objAdm.OutHospDate != '') ? objAdm.OutHospDate : '') + objAdm.VisitStatus +'</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.CurrLocDesc + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.InHospDate + '入院'+ ((objAdm.InHospLocDesc != objAdm.CurrLocDesc) ? ('('+objAdm.FromLocDesc+')') : '') + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + objAdm.InLocDate + '入科' + ((objAdm.FromLocDesc != '') ? ('('+objAdm.FromLocDesc+')') : '')  + '</li>'
				+ '		<li class="middle-line">|</li>'
				+ ' 	<li>' + ((objAdm.AdmDocDesc != '') ? objAdm.AdmDocDesc : '') + '(医)'+'</li>'
				+ '	</ul>'
				+ '</div>'
				
				//2. VAE筛查信息
				+ '	<div class="table-nobottom" style="border-left:1px solid #ccc;border-right:1px solid #ccc;border-bottom:1px solid #ccc;">'
				+ '	<div id=gridbtn'+EpisodeID+' style="padding:5px;border-bottom:1px solid #ccc;border-radius:0px;">'	
				+ '		<a id=btnSummer'+EpisodeID+' onclick="btnSummer_click(this,\'' + EpisodeID + '\',\'' +  pindex+ '\',\'' +  rindex + '\')"> 摘要 </a>'
				+ '	</div>'
				+ ' <table id=gridScreenInfo'+EpisodeID+' data-options="border:false" ></table>'				
				+ '	</div>'
				+ '	<div style="height:8px;border-right:1px solid #ccc;border-left:1px solid #ccc;border-radius:0px;">'
				+ '	</div>'
				+ '	<div style="border:1px solid #ccc; padding-bottom:5px;border-top-width:0px;border-radius:0px;">'
				+ ' 	<table id=gridSequence'+EpisodeID+' data-options="border:false" ></table>'	
				+ '	</div>'
				+ ' <div style="padding-bottom:10px;"></div>'
		$('#divMain').append(htmlStr);
		$('#btnSummer'+EpisodeID).linkbutton({
			iconCls: 'icon-tip',
			plain: true
		});
		
		obj.gridSequence(EpisodeID);
		obj.gridScreenInfo(EpisodeID,pindex,rindex);
		
		ResultID = $m({
			ClassName:"DHCHAI.IR.VAEResult",
			MethodName:"GetVAERstID",		
			aEpisodeID: EpisodeID
		},false);
		obj.gridScreenInfoLoad(EpisodeID,ResultID);
	}
	
	//加载时序图明细
	obj.gridSequence =function (aEpisodeID) {	
		$HUI.datagrid("#gridSequence"+aEpisodeID,{
			singleSelect: true,
			nowrap:true,
			showHeader:false,
			fitColumns: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: false, //如果为true, 则显示一个行号列 IRVAEDate
			loadMsg:'数据加载中...',
			columns:[[
				{field:'ItemDesc',title:'原因',width:80,align:'center',
					formatter: function(value,row,index){
						return "<span style='font-size:90%;'>"+value+"</span>";
					}	
				},
				{field:'Item1',title:'原因',width:46,align:'center',align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item2',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				}, 
				{field:'Item3',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item4',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				}, 
				{field:'Item5',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item6',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item7',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item8',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item9',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item10',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item11',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item12',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item13',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item14',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item15',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item16',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item17',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item18',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item19',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				},
				{field:'Item20',title:'原因',width:46,align:'center',
					formatter: function(value,row,index){
						if (row.ItemDesc=="日期"){
							if (row.IRVAEDate==value){
								return "<span style='font-size:88%;color:red;font-weight:bold;font-weight:bold;'>"+value+"</span>";
							}else{
								return "<span style='font-size:90%;'>"+value+"</span>";
							}
						}else if (row.ItemDesc=="发热"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/DHCMA/HAI/img/体温.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="检出菌"){
							if (value!=""){
								return '<span title="'+value + '">'+'<img src = "' + '../scripts/dhchai/img/细菌.png' + '"></img>'+'</span>';
							}else{ return "";}
						}else if (row.ItemDesc=="抗生素"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#FFE1E1;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else if (row.ItemDesc=="白细胞计数"){
							if (value!=""){
								return '<span title="'+value + '"><div style="background-color:#EEEE00;width:26px;height:24px;" ></div></span>';
							}else{ return "";}
						}else{
							return "<span style='font-size:90%;'>"+value+"</span>";
						}
					}	
				}
			]],
			rowStyler: function(index,row){
				if (row.ItemDesc=="日期"){
					return 'background-color:#f3f3f3;';
				}
			},
			onLoadSuccess:function(data){
				//$("#gridSequence"+aEpisodeID).siblings("div.datagrid-view2").children("div.datagrid-header").css('display', 'none');
			}
		});	
	}
	//加载时序图
	obj.gridSequenceLoad = function(aEpisodeID,aScreenID){
		$cm ({
			ClassName:'DHCHAI.IRS.VAEScreeningSrv',
			QueryName:'QrySequence',
			aEpisodeID:aEpisodeID,
			aRstID:aScreenID,
			page:1,      //可选项，页码，默认1			
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridSequence'+aEpisodeID).datagrid('loadData', rs);				
		});
	}
	
	//加载疑似筛查明细
    obj.gridScreenInfoLoad = function(EpisodeID,RstID){	
		$cm ({
			ClassName:'DHCHAI.IRS.VAEScreeningSrv',
			QueryName:'QrySuRuleResult',
			aEpisodeID:EpisodeID
		},function(rs){
			$('#gridScreenInfo'+EpisodeID).datagrid('loadData', rs);				
		});
		
		obj.gridSequenceLoad(EpisodeID,RstID);
    }
	//VAE筛查明细
	obj.gridScreenInfo = function(EpisodeID,pindex,rindex) {
		$HUI.datagrid("#gridScreenInfo"+EpisodeID,{
			singleSelect: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			fitColumns: true,   //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动。
			//nowrap: false,      //设置为 true，则把数据显示在一行里。false 超长折行显示。
			columns:[[
				{field:'xRstID',title:'操作',width:140,align:'center',
					formatter: function(value,row,index){
						if (row.xRstID) {
							if (row.ActStatus=='1') {    //已确诊项目
								return "<a style='color:#777;'>确诊</a>"
								+"&nbsp;&nbsp;<a href='#'  style='display: inline-block;' onclick='btnDel_click(this,\"" + EpisodeID + "\",\"" + index + "\",\"" +  pindex+ "\",\"" +  rindex + "\")' >排除</a>";
							}else if (row.ActStatus=='2') {    //已排除项目
								return "<a href='#'  style='display: inline-block;' onclick='btnOk_click(this,\"" + EpisodeID + "\",\"" + index +"\",\"" +  pindex+ "\",\"" +  rindex + "\")' >确诊</a>"
								+"&nbsp;&nbsp;<a style='color:#777;'>排除</a>";	
							}else if (row.PendingFlag=="1"){
								return "<a href='#' style='display: inline-block;' onclick='btnOk_click(this,\"" + EpisodeID + "\",\"" + index + "\",\"" +  pindex+ "\",\"" +  rindex + "\")' >确诊</a>" 
								+"&nbsp;&nbsp;<a href='#' onclick='btnDel_click(this,\"" + EpisodeID + "\",\"" + index +"\",\"" +  pindex+ "\",\"" +  rindex + "\")' >排除</a>";	
							}else{
								return "";
							}
						}else {						
							return '';
						}
					},
					styler: function(value,row,index){
						if (row.xRstID) {
							if (row.ActStatus=='1') {
								return 'border-top:5px solid #CCFFFF;'
							}else if (row.ActStatus=='2') {
								return 'backgroud:#cccccc'
							}
						}						
					}		
				},	
				{field:'VAEType',title:'VAE类型',width:100},	 				
				{field:'SItmDescs',title:'VAE相关指标',width:300},	
				{field:'MonitVAEDate',title:'VAE日期',width:120,showTip:true,tipWidth:150,
					formatter: function(value,row,index){
						var color='black';
						if (row.ActStatus=='0') {     //疑似、确诊后n之后有新疑似、排除后n之后有新疑似
							color= 'red;'; // return inline style
						}			
						if ((row.ActStatus=='')&&(row.ActStatus=='2')){    //删除的感染报告
							color= 'gray;'; // return inline style
						}			
						if (row.ActStatus=='2') {   //排除后无新疑似
							color= 'gray;'; // return inline style
						}
						return value;
					}
				},
				{field:'VAEActDate',title:'操作日期',width:140},
				{field:'ActUserDesc',title:'操作人',width:120},
				{field:'ExclReason',title:'排除原因',width:200}
			]],
			rowStyler: function(index,row){
				if (row.ActStatus=='0') {     //疑似、确诊后n之后有新疑似、排除后n之后有新疑似
					return 'color:red;'; // return inline style
				}			
				if ((row.xRstID=='')&&(row.ActStatus=='2')){    //删除的感染报告
					return 'color:gray;'; // return inline style
				}			
				if (row.ActStatus=='2') {   //排除后无新疑似
					return 'color:gray;'; // return inline style
				}
			},
			onSelect: function(rindex,field,value){  //展开时onSelect 执行两遍，换成onClickCell
			    //if (rindex>=obj.tatal) return;  //合计行在下方最后一行不允许操作
				//if ((rindex==0)&&(obj.tatal>1)) return;  //合计行在上方第一行不允许操作
				//if ( field=="_expander") return;
				if (rindex>-1) {
					var rowData = $("#gridScreenInfo"+EpisodeID).datagrid('getRows')[rindex];
					obj.gridScreen_onSelect(rindex,'',rowData);
				}	
			},
			onLoadSuccess:function(data){
				if (data.total<1){
					$('#btnOkAll'+EpisodeID).linkbutton("disable");
					$('#btnDelAll'+EpisodeID).linkbutton("disable");										
				}
			}
			
		});
	}
	//确诊 (单行确诊)
	btnOk_click = function (el,EpisodeID,rowIndex,pindex,rindex) {
		var arrData = new Array();
		$('#gridScreenInfo'+EpisodeID).datagrid('selectRow',rowIndex);// 获取点击当前行的索引
        var rData=$('#gridScreenInfo'+EpisodeID).datagrid("getSelected");//获取当前行数据
		arrData[arrData.length] =rData;
		var PendingFlag = rData.PendingFlag;
		obj.RstID = rData.xRstID;
		obj.pindex=pindex;
		obj.rindex=rindex;
		obj.ScreenData = arrData;
      	var InfData=EpisodeID+"^"+rData.VAItmCode+"^"+rData.VAEDate;					
		obj.InfDiagnos(EpisodeID,InfData); //VAE信息窗口
	}
	//VAE信息窗口
	obj.InfDiagnos = function(EpisodeID,InfData) {	
		obj.InitInfDialog(EpisodeID,InfData);		
		$HUI.dialog('#InfDiagnos',{
			title:'VAE信息',
			iconCls:'icon-w-paper', 
			width:400,
			height:167,  
			resizable:true,
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'保存',
				handler:function(){
					var VAEID = obj.OperConfirm(EpisodeID);	   //操作确诊
					if (!VAEID) return;
					if(parseInt(VAEID)>0){
						$HUI.dialog('#InfDiagnos').close();
						obj.gridScreenInfoLoad(EpisodeID,obj.RstID);
					}else{	
						$.messager.alert("提示","VAE信息保存失败！",'info');
					}				
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#InfDiagnos').close();
				}
			}]
		});      
	}
	
	//感染诊断窗口初始化
	obj.InitInfDialog = function(EpisodeID,rowData){ 
	    $('#InfDiagnos').show(); 		
		obj.InitDialog();

        obj.EpisodeID = EpisodeID;	
		if (rowData) {
			var arrData   = rowData.split("^");
			var VAItmCode  = arrData[1];
			var VAEDate    = arrData[2];
			$('#dtVAEDate').datebox('setValue',VAEDate);
			$('#cboVAEType').combobox('setText',VAItmCode);
				
		}else {	
			$('#dtVAEDate').datebox('clear');
			$('#cboVAEType').combobox('clear');
		}	
	}
	//VAE诊断窗口初始化
	obj.InitDialog = function(){
	 	//VAE
		$HUI.combobox("#cboVAEType",{
			data:[{Id:'1',text:'VAC',selected:true},{Id:'2',text:'IVAC'},{Id:'3',text:'VAP'}],
			valueField:'Id',
			textField:'text'
		});	
	}
	
	//确诊操作
	obj.OperConfirm = function (EpisodeID) {
		var errorStr = '';
		
		var VAEDate = $('#dtVAEDate').datebox('getValue');
		var VAEType = $('#cboVAEType').combobox('getText');
		
		if (!VAEDate) {
			errorStr = errorStr + "请填写VAE日期!<br>"; 
		}
		if (!VAEType) {
			errorStr = errorStr + "请填写VAE类型!<br>"; 
		}
		if (errorStr!="") { 
			$.messager.alert("提示", errorStr, 'info');
			return ; 
		}
		var retval="";	
		for (var m=0;m<obj.ScreenData.length;m++) {						
			var retval  = $m({
				ClassName:"DHCHAI.IR.VAEResult",
				MethodName:"UpdateVAERstOper",
				aRstID:obj.ScreenData[m].xRstID, 
				aActStatus:1, 
				aVAEDate:VAEDate,
				aVAEType:VAEType,
				aOperUser:$.LOGON.USERID,
				aExclReason:""
			},false);
			if (parseInt(retval)>0){
				$.messager.popover({msg: '确诊成功！',type:'success',timeout: 2000});
				//排除、确诊操作刷新界面
				if (obj.pindex) { //存在左侧列表
					obj.RefreshTable(EpisodeID,obj.pindex,obj.rindex);
				}
			}
		}
		return retval;
	}
	
	//刷新左侧数据
    obj.RefreshTable = function(EpisodeID,pindex,rindex) {	   
		var currPage=1;
		var expander = $('#gridLocVAE').datagrid('getExpander',pindex);  //获取展开行
		if(expander.length && expander.hasClass('datagrid-row-collapse')){  //未展开行获取不到页码信息，无需刷新明细
			if (rindex>=0) {
				var options = $('#gridAdmInfo'+pindex).datagrid("getPager").data("pagination").options;
				currPage = options.pageNumber; 
			}
		}
		
		var rows = $('#gridLocVAE').datagrid('getSelected',pindex);
		var LocID = rows.LocID;
		if (!LocID) {
			var LocID="";
		}
		var LocInfo = $cm({
			ClassName:"DHCHAI.IRS.VAEScreeningSrv",
			QueryName:"QrySuRuleLocList",
			aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aHospIDs:$('#cboHospital').combobox('getValue'), 
			aViewFlag:2,
			aLocID:LocID,
			aShowType:obj.ShowType
		},false);
		var ScreeningCnt=0,DealTodayCnt=0,ScreenActCnt=0,InPatientCnt=0
		if (LocID) {  
			ScreeningCnt = LocInfo.rows[0].ScreeningCnt;
			DealTodayCnt = LocInfo.rows[0].DealTodayCnt;
			ScreenActCnt = LocInfo.rows[0].ScreenActCnt;
			InPatientCnt = LocInfo.rows[0].InPatientCnt;
		}else { //合计行
		    for (var i=0;i<LocInfo.total;i++) {
			    ScreeningCnt += parseInt(LocInfo.rows[i].ScreeningCnt);
				DealTodayCnt += parseInt(LocInfo.rows[i].DealTodayCnt);
				ScreenActCnt += parseInt(LocInfo.rows[i].ScreenActCnt);
				InPatientCnt += parseInt(LocInfo.rows[i].InPatientCnt);
		    }
		}	
		$('#gridLocVAE').datagrid('updateRow', {
			index: pindex,
			row: {
				'ScreeningCnt':ScreeningCnt,
				'DealTodayCnt':DealTodayCnt,
				'ScreenActCnt':ScreenActCnt,
				'InPatientCnt':InPatientCnt
			}
		});
		if(expander.length && expander.hasClass('datagrid-row-collapse')){
			$('#gridLocVAE').datagrid('collapseRow',pindex); //折叠
			$('#gridLocVAE').datagrid('expandRow',pindex);   //展开						
			obj.SelectAdmRow(EpisodeID,pindex,currPage);  //刷新明细表格						
		}		
	}
	
	//刷新并选中明细表格数据
    obj.SelectAdmRow = function(EpisodeID,pindex,currPage){
		$('#gridAdmInfo'+pindex).datagrid({
			pageNumber:currPage,
			onLoadSuccess:function(data) {
				//获取数据列表中的所有数据
				var rows = data.rows;
				var length = rows.length;
				
				//循环数据找出列表中ID和需要选中数据的ID相等的数据并选中
				for(var i=0;i<length;i++){
					var rowIdID = rows[i].EpisodeID;  
					if(rowIdID==EpisodeID){
						var index = $('#gridAdmInfo'+pindex).datagrid("getRowIndex",rows[i]);
						$('#gridAdmInfo'+pindex).datagrid('scrollTo', index); //滚动到指定行
						$('#gridAdmInfo'+pindex).datagrid('selectRow', index); //选中指定行
					}
				}
		        
				setTimeout(function () {
					$('#gridLocVAE').datagrid('fixDetailRowHeight', pindex);
				}, 0);
			}
		});	
   }
   
	//排除(单行排除)
	btnDel_click = function (el,EpisodeID,rowIndex,pindex,rindex) {
		$('#gridScreenInfo'+EpisodeID).datagrid('selectRow',rowIndex);// 获取点击当前行的索引
        var rData=$('#gridScreenInfo'+EpisodeID).datagrid("getSelected");//获取当前行数据
		$('#DelOpnDialog').show();
		$('#txtOpinion').val('');
		obj.DelOpnDialog = $HUI.dialog('#DelOpnDialog',{
			title:'请输入排除原因',
			iconCls:'icon-w-cancel',  
			resizable:true,
			modal: true,
			isTopZindex:true,
			buttons:[{
				text:'确定',
				handler:function(){	
					var Opinion =  $.trim($('#txtOpinion').val());
					if (!Opinion) {
						$.messager.alert("提示", "请输入排除原因!", 'info');
						return;
					}
					OprDel(EpisodeID,rData,pindex,rindex,Opinion);
				}					
			},{
				text:'取消',
				handler:function(){
					$HUI.dialog('#DelOpnDialog').close();
				}
			}]
		});
	}
	
	function OprDel(EpisodeID,rData,pindex,rindex,Opinion) {
		var retval  = $m({
			ClassName:"DHCHAI.IR.VAEResult",
			MethodName:"UpdateVAERstOper",
			aRstID:rData.xRstID, 
			aActStatus:2, 
			aVAEDate:"",
			aVAEType:"",
			aOperUser:$.LOGON.USERID,
			aExclReason:Opinion
		},false);
		obj.RstID = rData.xRstID;
		if (parseInt(retval)<=0){
			$.messager.alert("提示", "排除失败!", 'info');
			return;
		} else {
			obj.gridScreenInfoLoad(EpisodeID,obj.RstID);
			$HUI.dialog('#DelOpnDialog').close();
			$.messager.popover({msg: '排除成功！',type:'success',timeout: 2000});
			
			//排除、确诊操作刷新界面
			if (pindex) { //存在左侧列表
				obj.RefreshTable(EpisodeID,pindex,rindex);
			}							
		}
	}
	//摘要
	btnSummer_click = function (el,EpisodeID,pindex,rindex,linkId) {
		var t=new Date();
		t=t.getTime();
        var strUrl = "./dhchai.ir.view.main.csp?PaadmID=" + EpisodeID +"&LocFlag="+""+ "&PageType=WinOpen&t=" + t+"&index="+(typeof(linkId)=="undifined"?"":linkId);
		
		//window.open样式打开
		var page=websys_createWindow(strUrl, 1, "width="+window.screen.availWidth-40+",height="+window.screen.availHeight-80+",toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	}
	
	
}


