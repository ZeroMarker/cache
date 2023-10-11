//页面Gui
var obj = new Object();
function InitCCScreeningWin(){
	obj.tatal = '';
	
	$('#aDateFrom').datebox('setValue',Common_GetDate(new Date()));
	$('#aDateTo').datebox('setValue',Common_GetDate(new Date()));
	if (LocFlag==1) {  //科室权限
		$('#divLayout').empty();
		$('#divLayout').css('display','none');
		
	}else{
		$('#divAccordion').empty();
		$('#divAccordion').css('display','none');
		
		//var HsopID = $.LOGON.HOSPID;
		//var UserID = $.LOGON.USERID;
		//var User = $.LOGON.USERDESC;
		
		//医院
		obj.cboHospital=Common_ComboToSSHospLoc("cboHospital",SSHospCode,"IMP");
		
		//医院表格联动
		$HUI.combobox('#cboHospital',{
			onSelect:function(data){
				//加载感染科室疑似筛查汇总  
				$('#aDateFrom').datebox('setValue',Common_GetDate(new Date()));
	 			$('#aDateTo').datebox('setValue',Common_GetDate(new Date()));
				obj.gridLocInf();
				obj.gridLocInfLoad();
			}
		});
		
		obj.cboCategory=$HUI.combobox("#cboCategory",{
				url:$URL+'?ClassName=DHCMA.IMP.BTS.IMPCategorySrv&QueryName=QryIMPCategory&aIsActive=1&ResultSetType=Array',
				valueField:'BTID',
				textField:'CateDesc',
				onSelect:function(data){
					obj.gridLocInf();
					obj.gridLocInfLoad();				
				},
				onLoadSuccess:function(){
					var data=$(this).combobox('getData');
					if (data.length>0){
						$(this).combobox('select',data[0]['BTID']);
					}
				}
		});
		obj.cboDateType =$HUI.combobox("#cboDateType",{
			valueField:'id',
			textField:'text',
			value:'0',
			data:[
				{id:'0',text:$g("发生日期")},{id:'1',text:$g("就诊日期")},{id:'2',text:$g("出院日期")}
			],
			onSelect:function(data){
				obj.gridLocInf();
				obj.gridLocInfLoad();				
			}
		});
	}
	
	//临床科室患者明细
   	obj.gridAdmInfo = function() {
		$HUI.datagrid("#gridAdmInfo",{
			fit: true,
			idField: "RecordID",
			pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏			
			singleSelect: true,
			autoRowHeight: false,
			striped:true,
			//rownumbers:true,
			sortName : 'CurrBed',
	    	sortOrder : 'asc',
			loadMsg:$g('数据加载中...'),
			pageSize: 10,
			pageList : [10,50],
			url:$URL,
			queryParams:{
		    	ClassName:"DHCMA.IMP.IPS.IMPRecordSrv",
				QueryName:"QryRecordPatList"
	    	},
			columns:[[
				{field:'CateFlag',title:'标记',width:60,align:'center',
					formatter: function(value,row,index){
						var StatusDesc = row["StatusDesc"];
						var CateDesc = row["CateDesc"];
						var IsEnd = row["IsEnd"];
						if(CateDesc != ""){
							if (StatusDesc==$g('确诊')) {
								return "<a class='hisui-tooltip' style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/img/spe/" + value+ "' width='16' height='16' alt='" +
								value + "-" + StatusDesc+"'  title='" + CateDesc + "-" + StatusDesc+"'>"
									 	+"<span style='position: absolute;color:red;bottom:6px;font-size:8px;transform:scale(0.8);'>确</span>"
										+"</a>";		
							}else if(StatusDesc==$g('排除')){
								return "<a class='hisui-tooltip' style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/img/spe/" + value+ "' width='16' height='16' alt='" +
								value + "-" + StatusDesc+"'  title='" + CateDesc + "-" + StatusDesc+"'>"
									 	+"<span style='position: absolute;color:red;bottom:6px;font-size:8px;transform:scale(0.8);'>排</span>"
										+"</a>";
							}else if(StatusDesc==$g('终结')){
								return "<a class='hisui-tooltip' style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/img/spe/" + value+ "' width='16' height='16' alt='" +
								value + "-" + StatusDesc+"'  title='" + CateDesc + "-" + StatusDesc+"'>"
									 	+"<span style='position: absolute;color:red;bottom:6px;font-size:8px;transform:scale(0.8);'>终</span>"
										+"</a>";
							}else{
								return "<a class='hisui-tooltip' style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/img/spe/" + value+ "' width='16' height='16' alt='" +
								value + "-" + StatusDesc+"'  title='" + CateDesc + "-" + StatusDesc+"'>"
										+"</a>";
							}
						}else{
							return '';
						}
					}
				},
				{field:'CurrBed',title:'床号',width:100},	 
				{field:'PatName',title:'姓名',width:85}, 
				{field:'HappenDate',title:'发生日期', width:'120', align:'left'},
				{field:'StatusDesc',title:'筛查状态', width:'120', align:'left',hidden:true},
				{field:'RecordID',title:'ID', width:'120', align:'left',hidden:true}
			]]
			,rowStyler: function(index,row){
				
			},
			onLoadSuccess:function(data){
				var sDate=$('#aDateFrom').datebox('getValue'),
				    eDate= $('#aDateTo').datebox('getValue');
				if(!sDate){
					$('#aDateFrom').datebox('setValue',Common_GetDate(new Date()));
					$('#aDateTo').datebox('setValue',Common_GetDate(new Date()));
				 }
				
				
			},
			onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
				//if ((field=='IsMessage')&&(value==1)) return;
				if (rindex>-1) {
					var rData = $('#gridAdmInfo').datagrid('getRows')[rindex];
					obj.gridAdmInfo_onSelect(rindex,'',rData);
				}	
			}
		});
	}
		

	//感染科室疑似筛查汇总
	obj.gridLocInf = function() {
		$HUI.datagrid("#gridLocInf",{   
			fit:true,
			nowrap:false,
			fitColumns:true,
			singleSelect:true,
			pagination:false,
			remoteSort:false,   //本地数据排序必须设置为false
			sortName:'LocDesc',
			sortOrder:'desc',
			loadMsg:$g('数据加载中...'),
			columns:[[ 
				{field:'LocDesc',title:'科室名称',width:170}, 
				{field:'ScreeningCnt',title:'筛查<br>人次数',width:50,align:'center'},
				{field:'ScreenProCnt',title:'疑似<br>人次数',width:65,align:'center'},
				{field:'ScreenExclude',title:'排除/确诊',width:85,align:'center',
					formatter: function(value,row,index){
						return row.ScreenExclude+" / "+row.ScreenDiagnosis;
					}
				}
				//{field:'ScreenExamine',title:'审核',width:65,align:'center'}
			]],
			view: detailview,
			detailFormatter:function(index, rowData){	
				if ((rowData.ScreeningCnt==0)&&(true)) {
					//无数据
					
					return '<div style="padding:8px;text-align:center;background-color:#E3F7FF;color:#1474AF;"><span class="icon-tip" style="margin-right:5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>无疑似患者</div>'
				}else {	
					//科室患者明细
					return '<div style="padding:5px 5px 5px 0px;"><table data-options="border:true,bodyCls:\'panel-body-gray\'" id=gridAdmInfo'+index+'></table></div>';
				}
			}, 
			onLoadSuccess:function(data){
				var sDate=$('#aDateFrom').datebox('getValue'),
				    eDate= $('#aDateTo').datebox('getValue');
				if(!sDate){
					$('#aDateFrom').datebox('setValue',Common_GetDate(new Date()));
					$('#aDateTo').datebox('setValue',Common_GetDate(new Date()));
				 }
				
				
			},
			onExpandRow: function(pindex, rowData){
				/**if (pindex>=obj.tatal) {  //合计行不展开数据
					$('#gridLocInf').datagrid('collapseRow',pindex);
					//$("#gridLocInf").datagrid('clearSelections');  //取消选中
				}**/
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
					//sortName:'SuspendCode',
					//sortOrder:'asc',
					sortName : 'CurrBed',
	    			sortOrder : 'asc',
					loadMsg:$g('数据加载中...'),
					url:$URL,
					queryParams:{
						ClassName:'DHCMA.IMP.IPS.IMPRecordSrv',
						QueryName:'QryRecordPatList',
						aDateFrom:$('#aDateFrom').datebox('getValue'), 
						aDateTo:$('#aDateTo').datebox('getValue'), 
						aLocID:rowData.LocID,
						aPatInfo:$('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val(),
						aCategory:$('#cboCategory').combobox('getValue'),
						aLocFlag:LocFlag,
						aDateType:$('#cboDateType').combobox('getValue')					
					},
					columns:[[
						{field:'CateFlag',title:'标记',width:70,align:'center',
							formatter: function(value,row,index){
								var StatusDesc = row["StatusDesc"];
								var CateDesc = row["CateDesc"];
								var IsEnd = row["IsEnd"];
								if(CateDesc != ""){
									if (StatusDesc==$g("确诊")) {
										return "<a class='hisui-tooltip' style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/img/spe/" + value+ "' width='16' height='16' alt='" +
								value + "-" + StatusDesc+"'  title='" + CateDesc + "-" + StatusDesc+"'>"
									 			+"<span style='position: absolute;color:red;bottom:6px;font-size:8px;transform:scale(0.8);'>确</span>"
												+"</a>";		
									}else if(StatusDesc==$g("排除")){
										return "<a class='hisui-tooltip' style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/img/spe/" + value+ "' width='16' height='16' alt='" +
								value + "-" + StatusDesc+"'  title='" + CateDesc + "-" + StatusDesc+"'>"
									 			+"<span style='position: absolute;color:red;bottom:6px;font-size:8px;transform:scale(0.8);'>排</span>"
												+"</a>";
									}else if(StatusDesc==$g("终结")){
										return "<a class='hisui-tooltip' style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/img/spe/" + value+ "' width='16' height='16' alt='" +
								value + "-" + StatusDesc+"'  title='" + CateDesc + "-" + StatusDesc+"'>"
									 			+"<span style='position: absolute;color:red;bottom:6px;font-size:8px;transform:scale(0.8);'>终</span>"
												+"</a>";
									}else{
										return "<a class='hisui-tooltip' style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/img/spe/" + value+ "' width='16' height='16' alt='" +
								value + "-" + StatusDesc+"'  title='" + CateDesc + "-" + StatusDesc+"'>"
												+"</a>";
									}
								}else{
									return '';
								}
							}
						},
						{field:'CurrBed',title:'床号',width:50},	 
						{field:'PatName',title:'姓名',width:80}, 
						{field:'link',title:'病历浏览',width:75,align:'center',
						formatter:function(value,row,index){
							console.log(row)
							 return "<a class='icon-search' href='#' onclick=obj.btnEmrRecord_Click(\""+row.EpisodeID+"\",\""+row.PatientID+"\")>&nbsp;&nbsp;&nbsp;&nbsp;</a>";
						}
					},
						{field:'HappenDate',title:'发生日期', width:'100', align:'left'}
					]]
					,rowStyler: function(index,row){
						
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
			    if (rindex>=obj.tatal) return;  //合计行不允许操作
				if ( field=="_expander") return;
				if (rindex>-1) {
					var rowData = $('#gridLocInf').datagrid('getRows')[rindex];
					//obj.gridLocInf_onSelect(rindex,'',rowData);
				}	
			},onLoadSuccess:function(data) {
				obj.tatal = data.total;   //获取原始数据行总数
				if (data.total>1) {					
					$('#gridLocInf').datagrid('appendRow',{
						LocDesc:'<span class="subtotal">全院合计</span>',
						ScreeningCnt:'<span class="subtotal">'+compute("ScreeningCnt")+'</span>',
						ScreenProCnt:'<span class="subtotal">'+compute("ScreenProCnt")+'</span>',
						ScreenExclude:'<span class="subtotal">'+compute("ScreenExclude")+'</span>',
						ScreenDiagnosis:'<span class="subtotal">'+compute("ScreenDiagnosis")+'</span>',
						ScreenExamine:'<span class="subtotal">'+compute("ScreenExamine")+'</span>'
					});
				}
			}
		});
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
	
	
	//加载医院方法
	function Common_ComboToSSHospLoc(){
		var ItemCode = arguments[0];
		var SSHospCode = arguments[1];
		var ProductCode = arguments[2];
	
		var cbox = $HUI.combobox("#"+ItemCode, {
			url: $URL,
			editable: true,
			defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			valueField: 'CTHospID',
			textField: 'CTHospDesc',
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCMed.SSService.HospitalSrv';
				param.QueryName = 'QrySSHospByCode';
				param.aHospCode = SSHospCode;
				param.aProductCode = ProductCode;
				param.ResultSetType = 'array';
			},		
			onLoadSuccess:function(){   //初始加载赋值
				var data=$(this).combobox('getData');
				if (data.length>0){
					$(this).combobox('select',data[0]['CTHospID']);
				}
			}
		});
		return  cbox;
	}
	
	InitPatDtl(obj);
	InitCCScreeningWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


