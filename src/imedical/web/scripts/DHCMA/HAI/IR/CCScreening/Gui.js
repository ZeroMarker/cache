//页面Gui
function InitCCScreeningWin(){
	var obj = new Object();
	LocGroupDr = ServerObj.LocGroupDr;
	LocGroupFlg = ServerObj.LocGroupFlg;
	obj.tatal = '';
	obj.UserID ='';
	//add 20210623 临床医生选中患者进入疑似病例筛查后默认选中列表中的患者
	var HAIEpisodeDr="";
	var frm = dhcsys_getmenuform();
	if (frm) {
		var papmi = frm.PatientID.value; //DHCDocMainView.PatientID;
		var adm = frm.EpisodeID.value; //DHCDocMainView.EpisodeID;
		var mradm = frm.mradm.value; //DHCDocMainView.EpisodeID;
		
		HAIEpisodeDr=$m({                
			ClassName:"DHCHAI.CUS.ToClinReport",
			MethodName:"GetEpisodeDr",
			aEpisodeID:adm,
		},false);
	}
	
	
	obj.ShowType = 1;
	if (LocFlag==1) {  //科室权限
		$('#divLayout').empty();
		$('#divLayout').css('display','none');
		
	}else {
		$('#divAccordion').empty();
		$('#divAccordion').css('display','none');
		
        var HsopID = $.LOGON.HOSPID;
		var UserID = $.LOGON.USERID;
		var User = $.LOGON.USERDESC;
		//obj.cboHospital = Common_ComboToSSHosp("cboHospital",HsopID);
		
		//医院表格联动
		$HUI.combobox('#cboHospital',{
			url: $URL,
			editable: true,
			allowNull: true, 
			defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			valueField: 'ID',
			textField: 'HospDesc',
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCHAI.BTS.HospitalSrv';
				param.QueryName = 'QryHospListByLogon';
				param.aLogonHospID = HsopID;
				param.ResultSetType = 'array';
			},
			onSelect:function(data){
				$('#cboGroup').combobox('clear');
				setTimeout(function(){
					obj.LoadGroup(data.ID);
					//加载感染科室疑似筛查汇总  
					obj.gridLocInf();
					obj.gridLocInfLoad();
				},1000);
			},
			onLoadSuccess:function(){   //初始加载赋值
				var data=$(this).combobox('getData');
				if (data.length>0){
					$(this).combobox('select',HsopID);
				}	
			}
		});
		obj.LoadGroup =  function(HsopID) {
			$HUI.combobox("#cboGroup", {
				url: $URL,
				editable: true,
				allowNull: true,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'GroupUser',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.IRS.CCLocGroupSrv';
					param.QueryName = 'QryLocGroupUser';
					param.aHospIDs  = HsopID;
					param.aViewFlag = "W";
					param.aGrpType  = LocGroupDr;
					param.ResultSetType = 'array';
				},
				onSelect:function(data){
					if (LocGroupFlg==1) {
						//加载感染科室疑似筛查汇总
						obj.gridLocInfLoad();
					}						
				},
				onChange:function(newValue,oldValue){   //清空当前工作组，显示全部信息
					if (LocGroupFlg==1){ 
						//加载感染科室疑似筛查汇总
						obj.gridLocInfLoad();
					}						
				},
				onLoadSuccess:function(data){   //初始加载赋值
					if (data.length>0){
						$(this).combobox('enable');
						for (var i=0;i<data.length;i++) {
							if (User == data[i]['GroupUser']) {
								$(this).combobox('select',data[i]['ID']);
							}
						}
					}else {
						$(this).combobox('select',data[0]['ID']);
					}
				}
			});
		}
	}
	
	//临床科室患者明细
   	obj.gridAdmInfo = function() {
		$HUI.datagrid("#gridAdmInfo",{
			fit: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			loadMsg:'数据加载中...',
			columns:[[
				{field:'RegNo',title:'登记号',width:100},
				{field:'PatName',title:'姓名',width:72}, 
				{field:'CurrBed',title:'床号',width:53,align:'center'},
				{field:'IsMessage',title:'消息',width:42,align:'center',
					formatter: function(value,row,index){
						if (value==1) {
							return "<a style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/HAI/img/消息-选中.png'>"
									+((row.LocUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:8px;'>"+$g("未")+"</span>":'')
									+"</a>";		
						}else {
							return '';
						}
					}	
				},	
				{field:'IsNeedAtt',title:'需关注',width:58,align:'center',
					formatter: function(value,row,index){
						if (value==1){
							return "<a class='icon-star-yellow'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"		
						}else{
							return '';
						}	
					}
				},
				{field:'NeedRepCnt',title:'需上报',width:58,align:'center',
					formatter: function(value,row,index){
						if ((row.IsReport=='0')&&(value=='0')) {
							return '';
						}else {
							if ((row.IsReport==1)&&(value>=1)){
								return "<a style='position: relative;'><img  src='../scripts/DHCMA/HAI/img/star.png'></a>"+" "+"<a style='position: relative;'><img src='../scripts/DHCMA/HAI/img/star_half.png'></a>"		
							}else if ((row.IsReport==1)&&(value<1)){
								return "<a class='icon-star'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"		
							}else {
								return "<a class='icon-star-half'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"		
							}
						}
					}
				}
			]]
			,rowStyler: function(index,row){
				if (row.IsSusInf==1) { //疑似
					if (row.SuspendCode==0){   //0待处理  1已处理
						return 'color:red'; 
					}
					if (row.SuspendCode==1){   
						return 'color:black'; 
					}
				}else {
					return 'color:gray'; 
				}
			},onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
				//if ((field=='IsMessage')&&(value==1)) return;
				if (rindex>-1) {
					var rData = $('#gridAdmInfo').datagrid('getRows')[rindex];
					obj.gridAdmInfo_onSelect(rindex,'',rData);
				}	
			},
			onLoadSuccess:function(data){
				var total = data.total;
				if	(total>0) {	
	                if (HAIEpisodeDr) {
						for (r=0;r<total;r++) {
							if (HAIEpisodeDr==data.rows[r].EpisodeID) {
								$(this).datagrid('selectRow',r);
								obj.gridAdmInfo_onSelect(r,'',data.rows[r]);
								continue;
							}
						}
					} 
				}
			}
		});
	}
	
	//责任患者列表
	obj.gridDutyList = function() {
		$HUI.datagrid("#gridDutyList",{
			fit: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏,默认显示50条数据
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			loadMsg:'数据加载中...',
			columns:[[
				{field:'RegNo',title:'登记号',width:100},
				{field:'PatName',title:'姓名',width:72}, 
				{field:'CurrBed',title:'床号',width:53,align:'center'},
				{field:'IsMessage',title:'消息',width:42,align:'center',
					formatter: function(value,row,index){
						if (value==1) {
							return "<a style='position: relative;' ><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/HAI/img/消息-选中.png'>"
									+((row.LocUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:12px;transform: scale(0.8)'>"+$g("未")+"</span>":'')
									+"</a>";							
						}else {
							return '';
						}
					}	
				},	
				{field:'IsNeedAtt',title:'需关注',width:58,align:'center',
					styler: function(value,row,index){
						if (row.IsNeedAtt==1){
							//return 'background-color:#00FFFF;';
							return "<a href='#' class='icon-star-yellow' data-options='plain:true,'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"
							
						}else{
							return '';
						}
					}
				},
				{field:'NeedRepCnt',title:'需上报',width:58,align:'center',
					formatter: function(value,row,index){
						if ((row.IsReport=='0')&&(value=='0')) {
							return '';
						}else {
							if ((row.IsReport==1)&&(value>=1)){
								return "<a style='position: relative;'><img  src='../scripts/DHCMA/HAI/img/star.png'></a>"+" "+"<a style='position: relative;'><img src='../scripts/DHCMA/HAI/img/star_half.png'></a>"		
							}else if ((row.IsReport==1)&&(value<1)){
								return "<a class='icon-star'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"		
							}else {
								return "<a class='icon-star-half'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"		
							}
						}
					}
				}
			]]
			,rowStyler: function(index,row){
				if (row.IsSusInf==1) { //疑似
					if (row.SuspendCode==0){   //0待处理  1已处理
						return 'color:red'; 
					}
					if (row.SuspendCode==1){   
						return 'color:black'; 
					}
				}else {
					return 'color:gray'; 
				}
			},onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
				if (rindex>-1) {
					var rData = $('#gridDutyList').datagrid('getRows')[rindex];
					obj.gridAdmInfo_onSelect(rindex,'',rData);
				}	
			}
		});
	}

	//感染科室疑似筛查汇总
	obj.gridLocInf = function() {
		$HUI.datagrid("#gridLocInf",{   
			fit:true,
			//nowrap:false,
			fitColumns:true,
			singleSelect:true,
			pagination:false,
			remoteSort:false,   //本地数据排序必须设置为false
			sortName:'LocDesc',
			sortOrder:'desc',
			loadMsg:'数据加载中...',
			columns:[[ 
				{field:'LocDesc',title:'科室名称',width:240,hidden:true,
				formatter:function(value,row,index){
				if(row.LocID!=undefined){
					return '<a href="#" onclick=ShowWardInfo(\''+row.LocID+'\',\''+row.LocDesc+'\')>'+row.LocDesc+'</a>';
				}	
				else{
					return row.LocDesc
				}	
				}
			},
				{field:'ScreenProCnt',title:'待处理',width:100,align:'center',hidden:true},
				{field:'DealTodayCnt',title:'今日处理',width:120,align:'center',hidden:true},			
				{field:'ScreenLogCnt',title:'已处理',width:100,align:'center',hidden:true},
				{field:'ConfirmCnt',title:'确诊</br>人数',width:80,align:'center',hidden:true}, 
				{field:'DiagOutCnt',title:'社区</br>感染',width:80,align:'center',hidden:true},
				{field:'DiagNoRepCnt',title:'未报</br>人数',width:80,align:'center',hidden:true}, 
				{field:'ScreenAttCnt',title:'需关注',width:100,align:'center',hidden:true}, 
				{field:'ReportCnt',title:'报告例数',width:120,align:'center',hidden:true}, 
				{field:'UnCheckCnt',title:'未审核例数',width:130,align:'center',hidden:true},  
				{field:'InPatientCnt',title:'在科人数',width:100,align:'center',hidden:true}
			]],
			view: detailview,
			autoUpdateDetail:false,   //合计行放在最上方时，这个属性必须设置为false，否则更新行内容后无法展示明细数据
			detailFormatter:function(index, rowData){	
				//科室患者明细
				//合计行在上方第一行
				var rows = $('#gridLocInf').datagrid('getRows');
				var total = rows.length;
				if (total>1) {
					if (!rowData.LocID) {
						return '<div style="padding:5px 5px 5px 0px;"><table id=gridAdmInfo'+index+'></table></div>';	
					}else {
						return '<div style="padding:5px 5px 5px 0px;"><table id=gridAdmInfo'+(index+1)+'></table></div>';	
					}
				}
				if (total==1) {
					//只有一行不加合计行
					return '<div style="padding:5px 5px 5px 0px;"><table id=gridAdmInfo'+index+'></table></div>';
				}
				//合计行在下方最后一行
				//return '<div style="padding:5px 5px 5px 0px;"><table id=gridAdmInfo'+index+'></table></div>';	
			}, 
			onExpandRow: function(pindex, rowData){
				/*
				//if (pindex>=obj.tatal) {  //合计行在下方最后一行不展开数据			
				if (pindex==0) { //合计行在上方第一行不允许操作
					$('#gridLocInf').datagrid('collapseRow',pindex);
					$("#gridLocInf").datagrid('clearSelections');  //取消选中
				}
				*/
				var rows = $('#gridLocInf').datagrid('getRows');
				$.each(rows,function(i,k){
					//获取当前所有展开的子网格
					var expander = $('#gridLocInf').datagrid('getExpander',i);
					if(expander.length && expander.hasClass('datagrid-row-collapse')){
						if(k.LocID != rowData.LocID){
							//折叠上一次展开的子网格
							$('#gridLocInf').datagrid('collapseRow',i);
						}
					}
				});
				
				obj.gridLocAdmInfo = $HUI.datagrid('#gridAdmInfo'+pindex,{   //科室患者明细
				    idField:'EpisodeID',
					pageSize: 10,
					pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
					showPageList:false,  //不显示页面尺寸的选择列表		
					singleSelect: true,
					autoRowHeight: true,
					fitColumns: true,
					loadMsg:'数据加载中...',
					url:$URL,
					queryParams:{
						ClassName:'DHCHAI.IRS.CCScreeningSrv',
						QueryName:'QrySuRulePatList',
						aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
						aDateFrom:$('#aDateFrom').datebox('getValue'), 
						aDateTo:$('#aDateTo').datebox('getValue'), 
						aLocID:rowData.LocID,
						aIsInf:'', 
						aPatInfo:$('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val(),
						aShowType:obj.ShowType,
						aHospIDs:$('#cboHospital').combobox('getValue'),
						aViewFlag:2,
						aGroupUser:$('#cboGroup').combobox('getText'),
						aCLABSIFlag:CLABSIFlag				
					},
					columns:[[
						{field:'SuspendCode',title:'状态',hidden:true}, 
						{field:'RegNo',title:'登记号',width:100},	 
						{field:'PatName',title:'姓名',width:75}, 
						{field:'Sex',title:'性别',width:45}, 
						{field:'CurrBed',title:'床号',width:48,align:'center',
							styler: function(value,row,index){
								if (row.NeedRepCnt>0) {
									return 'background-color:#CCFFFF';	
								}
							}	
						},
						{field:'IsMessage',title:'需关注',width:95,
							formatter: function(value,row,rindex){
							    var MsgStr="",NeedStr="",StatusStr=""
								if (value==1) {
									MsgStr= "<a style='position: relative;' ><img onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + pindex +  "\",\"" + rindex + "\")' src='../scripts/DHCMA/HAI/img/消息-选中.png'>"	
									+((row.AdminUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:12px;transform: scale(0.8)'>"+$g("未")+"</span>":'')
									+"</a>";	
								}
								if(row.IsNeedAtt==1) {
									NeedStr="<img src='../scripts/DHCMA/HAI/img/关注-选中.png'>";	
								}
								if (row.SureFlag==1) {
									if (row.NeedRepCnt>0) {
										StatusStr="<img src='../scripts/DHCMA/HAI/img/确.png'>";
									}else {
										if (row.OutCnt>0) {
											StatusStr="<a style='position: relative;' ><img src='../scripts/DHCMA/HAI/img/确.png'><span style='position: absolute;color:red;bottom:8px;font-size:12px;transform: scale(0.8)'>社</span></a><a style='padding-left:8px;'></a>";																		
										} 
									}
								}else if(row.SureFlag==2){
									StatusStr= "<img src='../scripts/DHCMA/HAI/img/排.png'>";	
								}
								return  StatusStr+" "+NeedStr+" "+MsgStr;
							}	
						}
					]]
					,rowStyler: function(index,row){
						if (row.IsSusInf==1) {  //疑似
							//if ((row.SuspendCode==0)&&(!$("#chkIsInf").checkbox('getValue'))){   //0待处理  1已处理
							if (row.SuspendCode=='0') {
								return 'color:red'; 
							}
							if (row.SuspendCode=='1'){   
								return 'color:balck'; 
							}
						}else {
							return 'color:gray'; 
						}
					},
					onResize: function () {
						$('#gridLocInf').datagrid('fixDetailRowHeight', pindex);
					},
					onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
						if (rindex>-1) {
							var rData = $('#gridAdmInfo'+pindex).datagrid('getRows')[rindex];
							obj.gridAdmInfo_onSelect(pindex,rindex,rData);
						}	
					},
					onLoadSuccess: function (data) {
						setTimeout(function () {
							$('#gridLocInf').datagrid('fixDetailRowHeight', pindex);
						}, 0);
					}				
				});
			}
			,onClickCell: function(rindex,field,value){  //展开时onSelect 执行两遍，换成onClickCell
			    //if (rindex>=obj.tatal) return;  //合计行在下方最后一行不允许操作
				if ((rindex==0)&&(obj.tatal>1)) return;  //合计行在上方第一行不允许操作
				if ( field=="_expander") return;
				if (rindex>-1) {
					var rowData = $('#gridLocInf').datagrid('getRows')[rindex];
					obj.gridLocInf_onSelect(rindex,'',rowData);
				}	
			},onLoadSuccess:function(data) {
				//显示列				
				window.setTimeout(function () {	
					$("#gridLocInf").datagrid("showColumn", "LocDesc");
					if (obj.ShowType==1) {
						 $("#gridLocInf").datagrid("showColumn", "ScreenProCnt");					
						 if(Common_RadioValue('radAdmStatus')==1) {
						 	$("#gridLocInf").datagrid("showColumn", "DealTodayCnt");
						 }else {
							 $("#gridLocInf").datagrid("hideColumn", "DealTodayCnt");
						 }
					}else if (obj.ShowType==2) { //确诊未报
						 $("#gridLocInf").datagrid("showColumn", "ConfirmCnt");
						 $("#gridLocInf").datagrid("showColumn", "DiagOutCnt");
						 $("#gridLocInf").datagrid("showColumn", "DiagNoRepCnt");						 						 
					}else if (obj.ShowType==3) {  //需关注
						 $("#gridLocInf").datagrid("showColumn", "ScreenAttCnt");
					}else if (obj.ShowType==4) {  //已处理
						 $("#gridLocInf").datagrid("showColumn", "ScreenLogCnt");
						 $("#gridLocInf").datagrid("showColumn", "ConfirmCnt");
					}else if (obj.ShowType==5) {  //报告未审核
						 $("#gridLocInf").datagrid("showColumn", "ReportCnt");
						 $("#gridLocInf").datagrid("showColumn", "UnCheckCnt");
					}else{  //全院所有默认不传参数
						 $("#gridLocInf").datagrid("showColumn", "InPatientCnt");
					}				
				}, 200); 
					
				obj.tatal = data.total;   //获取原始数据行总数
				if (data.total>1) {		
                   	 /*		
					//合计行在下方最后一行
					$('#gridLocInf').datagrid('appendRow',{
						LocDesc:'<span class="subtotal">合计</span>',
						InPatientCnt:'<span class="subtotal">'+compute("InPatientCnt")+'</span>',
						DealTodayCnt:'<span class="subtotal">'+compute("DealTodayCnt")+'</span>',
						ScreenLogCnt:'<span class="subtotal">'+compute("ScreenLogCnt")+'</span>',
						ScreenProCnt:'<span class="subtotal">'+compute("ScreenProCnt")+'</span>',
						DiagNoRepCnt:'<span class="subtotal">'+compute("DiagNoRepCnt")+'</span>',
						ConfirmCnt:'<span class="subtotal">'+compute("ConfirmCnt")+'</span>',
						ScreenAttCnt:'<span class="subtotal">'+compute("ScreenAttCnt")+'</span>',
						ReportCnt:'<span class="subtotal">'+compute("ReportCnt")+'</span>',
						UnCheckCnt:'<span class="subtotal">'+compute("UnCheckCnt")+'</span>',
						DiagOutCnt:'<span class="subtotal">'+compute("DiagOutCnt")+'</span>'
					});
					*/
					//合计行在上方第一行
					$('#gridLocInf').datagrid('insertRow',{
						index: 0,   // 索引从0开始
						row: {
							LocDesc:'<span class="subtotal">合计</span>',
							InPatientCnt:'<span class="subtotal">'+compute("InPatientCnt")+'</span>',
							DealTodayCnt:'<span class="subtotal">'+compute("DealTodayCnt")+'</span>',
							ScreenLogCnt:'<span class="subtotal">'+compute("ScreenLogCnt")+'</span>',
							ScreenProCnt:'<span class="subtotal">'+compute("ScreenProCnt")+'</span>',
							DiagNoRepCnt:'<span class="subtotal">'+compute("DiagNoRepCnt")+'</span>',
							ConfirmCnt:'<span class="subtotal">'+compute("ConfirmCnt")+'</span>',
							ScreenAttCnt:'<span class="subtotal">'+compute("ScreenAttCnt")+'</span>',
							ReportCnt:'<span class="subtotal">'+compute("ReportCnt")+'</span>',
							UnCheckCnt:'<span class="subtotal">'+compute("UnCheckCnt")+'</span>',
							DiagOutCnt:'<span class="subtotal">'+compute("DiagOutCnt")+'</span>'
						}
					});
				}
			}
		});
		$('.datagrid-sort-icon').css("display", "none");
	}
	
	//指定列求和
	function compute(colName) {
		var rows = $('#gridLocInf').datagrid('getRows');
		
		var total = 0;
		for (var i = 0;i<rows.length;i++) {
			total +=parseFloat(rows[i][colName]);
		}
		return total;
	}
	
	
	 //加载表格
	 obj.gridNeedAttList = function() {
		$HUI.datagrid("#gridNeedAttList",{
			fit: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			remoteSort:false,   //本地数据排序必须设置为false
			sortName:'LocDesc',
			sortOrder:'desc',
			loadMsg:'数据加载中...',
			columns:[[
				{field:'LocDesc',title:'科室名称',width:100},
				{field:'PapmiNo',title:'登记号',width:100},
				{field:'PatName',title:'姓名',width:58}, 
				{field:'CurrBed',title:'床号',width:50,align:'center'},
				{field:'LocUnRead',title:'消息',width:40,align:'center',
					formatter: function(value,row,index){
						if ((row.LocUnRead=='1')&&(row.AdminUnRead=='0')) { //院感科消息，科室未阅读
							return "<a style='position: relative;' class='icon-have-message hisui-tooltip' title='临床科室未阅读院感科消息'>&nbsp;&nbsp;&nbsp;&nbsp;<span style='position: absolute;color:red;bottom:5px;font-size:12px;transform: scale(0.8)'>"+$g("未")+"</span></a>"   //院感科消息，科室未阅读
						} 
						if((row.LocUnRead=='0')&&(row.AdminUnRead=='1')) { //院感科消息，科室未阅读
							return "<a style='position: relative;' class='icon-send-msg hisui-tooltip' title='院感科未阅读科室消息'>&nbsp;&nbsp;&nbsp;&nbsp;<span style='position: absolute;color:red;bottom:5px;font-size:12px;transform: scale(0.8)'>"+$g("未")+"</span></a>" //科室消息，临床未阅读;							
						} 
						if((row.LocUnRead=='1')&&(row.AdminUnRead=='1')) { //院感科消息、科室消息未阅读
						   return "<a style='position: relative;' title='院感科、临床未阅读消息'><img src='../scripts/DHCMA/HAI/img/消息-选中.png'></a>"
						}
					}	
				},	
				{field:'NeedRepCnt',title:'需上报',width:55,align:'center'}
			]]
			,rowStyler: function(index,row){
				if (row.IsSusInf==1) { //疑似
					if (row.SuspendCode==0){   //0待处理  1已处理
						return 'color:red'; 
					}
					if (row.SuspendCode==1){   
						return 'color:black'; 
					}
				}else {
					return 'color:gray'; 
				}
			},onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
				if (rindex>-1) {
					var rData = $('#gridNeedAttList').datagrid('getRows')[rindex];
					gridNeedAttList_onSelect(rindex,'',rData);
				}	
			},
			onLoadSuccess:function(data){
				dispalyEasyUILoad(); //隐藏效果
			}
		});
	}
		
	//加载需关注患者明细
	obj.gridNeedAttListLoad = function()  {
		$("#gridNeedAttList").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.IRS.CCScreenAttSrv',
			QueryName:'QryNeedAtt',
			aHospIDs:$('#cboHospital').combobox('getValue'),
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 		
			page:1,      //可选项，页码，默认1			
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridNeedAttList').datagrid('loadData', rs);				
		});
	}
	
	
	 //加载确诊未报表格
	obj.gridNoRepList =function () {
		$HUI.datagrid("#gridNoRepList",{
			fit: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			remoteSort:false,   //本地数据排序必须设置为false
			sortName:'CurrLoc',
			sortOrder:'desc',
			loadMsg:'数据加载中...',
			columns:[[
				{field:'CurrLoc',title:'科室名称',width:100},
				{field:'RegNo',title:'登记号',width:100},
				{field:'PatName',title:'姓名',width:58}, 
				{field:'CurrBed',title:'床号',width:50,align:'center',
					styler: function(value,row,index){
						if (row.IsNeedAtt==1) {  //需关注
							return 'background-color:#CCFFFF';	
						}
					}	
				},
				{field:'IsMessage',title:'消息',width:40,align:'center',
					formatter: function(value,row,index){
						if (value==1) {
							return "<a style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/HAI/img/消息-选中.png'>"
									+((LocFlag==1)&&(row.LocUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:12px;transform: scale(0.8)'>"+$g("未")+"</span>":'')
									+((LocFlag!=1)&&(row.AdminUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:12px;transform: scale(0.8)'>"+$g("未")+"</span>":'')
									+"</a>";		
						}else {
							return '';
						}
					}	
				},	
				{field:'NeedRepCnt',title:'需上报',width:55,align:'center'}
			]]
			,rowStyler: function(index,row){
				if (row.IsSusInf==1) { //疑似
					if (row.SuspendCode==0){   //0待处理  1已处理
						return 'color:red'; 
					}
					if (row.SuspendCode==1){   
						return 'color:black'; 
					}
				}else {
					return 'color:gray'; 
				}
			},onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
				if (rindex>-1) {
					var rData = $('#gridNoRepList').datagrid('getRows')[rindex];
					gridNoRepList_onSelect(rindex,'',rData);
				}	
			},
			onLoadSuccess:function(data){
				dispalyEasyUILoad(); //隐藏效果
			}
		});
	}
	
	//加载确诊未报患者明细
	obj.gridNoRepListLoad = function(){
		$("#gridNoRepList").datagrid("loading");
		$cm ({
			ClassName:'DHCHAI.IRS.CCScreeningSrv',
			QueryName:'QryInfNoRep',
			aDateFrom:$('#aDateFrom').datebox('getValue'), 
			aDateTo:$('#aDateTo').datebox('getValue'), 
			aHospIDs:$('#cboHospital').combobox('getValue'),
			page:1,      //可选项，页码，默认1			
			rows:999    //可选项，获取多少条数据，默认50
		},function(rs){
			$('#gridNoRepList').datagrid('loadData', rs);				
		});
	}
	InitPatDtl(obj);
	InitCCScreeningWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


