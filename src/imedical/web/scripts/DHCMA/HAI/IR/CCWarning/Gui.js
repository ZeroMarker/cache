//页面Gui
var objScreen = new Object();
var obj = new Object();
function InitCCScreeningWin(){
	obj.selItem = "";
	obj.OperationFlg = ""; 
	obj.qryWarnDate = "";
	obj.qryWarnItems = "";
	//设置日期为当月1号
	var qryDate=Common_GetDate(new Date());
	Common_SetValue('qryDate',qryDate);
	
	var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	obj.HospData = HospList.rows;
    $HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:obj.HospData,
		onSelect:function(rec){
			//obj.qryWarning();
		},onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	var WarnItems =$("#WarnItem_FerverName2").html() + "|" + $("#WarnItem_FerverDay2").val() + "|" + $("#WarnItem_FerverCnt2").val();  //发热标准差
	WarnItems += "^" + $("#WarnItem_FerverName").html() + "|" + $("#WarnItem_FerverDay").val() + "|" + $("#WarnItem_FerverCnt").val();  //发热人数
	WarnItems += "^" + $("#WarnItem_BactName").html() + "|" + $("#WarnItem_BactDay").val() + "|" + $("#WarnItem_BactCnt").val();		//同种同源菌
	//感染
	WarnItems += "^" + "实时现患" + "|" + $("#WarnItem_DayDay").val() + "|" + $("#WarnItem_DayCnt").val();
	var IsActive =$("#WarnItem_24Hour").checkbox('getValue');
	IsActive = (IsActive==true? 1: 0);
	WarnItems += "^入院24H内计入|" + IsActive;
	obj.qryWarnItems = WarnItems;
	obj.qryWarnDate=$("#qryDate").datebox('getValue');
	
	//表格	
	obj.gridBfyj = $('#gridBfyj').datagrid({
        fit:true,
        //title:'监测结果',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        singleSelect:true,
        nowrap:true,
		fitColumns: true,
        loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
        queryParams:{
	        ClassName:'DHCHAI.IRS.NewCCWaringSrv',
	        QueryName:'QryWarnResult',
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aWarnDate:$("#qryDate").datebox('getValue'),
	        aWarnItems:WarnItems
	    },
        columns:[[
        	{ field:"LocDesc",title:"科室名称",width:150,align:'center',
        		/*formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.OperKSWin_Click('+row.LocID+')>'+row.LocDesc+'</a>';
				}*/
        	},
			{ field:"fr",title:"发热",width:140,align:'center',
				formatter:function(value,row,index){
					var rowData=row.FrPeo1;
					var rowData2=row.FrBzc;
					var frHtml="";						
					if(rowData>'0'){
						var Status=obj.StatusValue("发热人数",row.LocID);
						if(Status==2){
							frHtml='<div class="common1" style="border-right-color:#C0C0C0;" onclick=obj.gridBfyj_Click("发热人数1"'+","+row.LocID+')><p class="text" style="width:110px;">发热人数 <strong style="margin-left:20px;" onclick=obj.LocPatients_Click("发热人数1"'+","+row.LocID+')>'+rowData+'</strong></p></div>'
						}else{
							frHtml='<div class="common" style="border-right-color:#FFA54A;" onclick=obj.gridBfyj_Click("发热人数1"'+","+row.LocID+')><p class="text" style="width:110px;">发热人数 <strong style="margin-left:20px;" onclick=obj.LocPatients_Click("发热人数1"'+","+row.LocID+')>'+rowData+'</strong></p></div>'
						}
					}
					if(rowData2>'0'){
						var Status=obj.StatusValue("发热方差",row.LocID)
						if(Status==2){
							frHtml+='<div class="common1 fcrs1" style="border-right-color:#C0C0C0;" onclick=obj.gridBfyj_Click("发热人数2"'+","+row.LocID+')><p class="text" style="width:110px;">发热方差 <strong style="margin-left:20px;" onclick=obj.LocPatients_Click("发热人数2"'+","+row.LocID+')>'+rowData2+'</strong></p></div>'
						}else{
							frHtml+='<div class="common fcrs" style="border-right-color:#FF8160;" onclick=obj.gridBfyj_Click("发热人数2"'+","+row.LocID+')><p class="text" style="width:110px;">发热方差 <strong style="margin-left:20px;" onclick=obj.LocPatients_Click("发热人数2"'+","+row.LocID+')>'+rowData2+'</strong></p></div>'
						}
					} 
					return  frHtml;
				}
			},
			{ field:"ssxh",title:"实时现患",width:420,align:'center',
				formatter:function(value,row,index){
					var ssxhHtml="";
					var rowData=row.SNum.split("^");
					var Rhtml='<div class="common ssxh right" style="border-right-color:#00C1FF;">'
					var Lhtml='<div class="common ssxh left" style="border-right-color:#00C1FF;">'
					var index=2;
					for(var i=0;i<rowData.length;i++){
						var rows=rowData[i];
						var NameNum=rows.split("#");
						var Name=NameNum[0];
						var Num=NameNum[1];
						if(Num>0){
							var Status=obj.StatusValue(Name,row.LocID);
							if(Status==2){
								Rhtml='<div class="common ssxh1 right" style="border-right-color:#C0C0C0;">'
								Lhtml='<div class="common ssxh1 left" style="border-right-color:#C0C0C0;">'
							}
							if(index%2!=0){
								ssxhHtml+=Rhtml+'<p class="text" style="width:180px;" onclick=obj.gridBfyj_Click(\'' + Name + '\',\'' + row.LocID + '\')>'+Name+' <strong class="Numtext" onclick=obj.LocPatients_Click(\'' + Name + '\',\'' + row.LocID + '\')>'+Num+'</strong></p></div>'
							}else{
								ssxhHtml+=Lhtml+'<p class="text" style="width:180px;" onclick=obj.gridBfyj_Click(\'' + Name + '\',\'' + row.LocID + '\')>'+Name+' <strong class="Numtext"onclick=obj.LocPatients_Click(\'' + Name + '\',\'' + row.LocID + '\')>'+Num+'</strong></p></div>'
							}
							index+=1;
							Rhtml='<div class="common ssxh right" style="border-right-color:#00C1FF;">'
						 	Lhtml='<div class="common ssxh left" style="border-right-color:#00C1FF;">'
						} 
					}					
					return  ssxhHtml
				}
			},
			{ field:"tztyj",title:"同种同源菌",width:190,align:'center',
				formatter:function(value,row,index){
					var tztyjHtml="";
					var rowData=row.TzBac.split("^");
					var Rhtml='<div class="common tzty" style="border-right-color:#58EB8E;">'
					var Lhtml='<div class="common tzty" style="border-right-color:#58EB8E;">'
					var index=2;
					for(var i=0;i<rowData.length;i++){
						var rows=rowData[i];
						var NameNum=rows.split("#");
						var Name=NameNum[0];
						var Num=NameNum[1];
						if(Num>0){
							var Status=obj.StatusValue(Name,row.LocID);
							if(Status==2){
								Rhtml='<div class="common tzty1" style="border-right-color:#C0C0C0;">'
								Lhtml='<div class="common tzty1" style="border-right-color:#C0C0C0;">'
							}
							if(index%2!=0){
								tztyjHtml+=Rhtml+'<p class="text" style="width:150px;" onclick=obj.gridBfyj_Click(\'' + Name + '\',\'' + row.LocID + '\')>'+Name+'<strong class="Numtext" onclick=obj.LocPatients_Click(\'' + Name + '\',\'' + row.LocID + '\')>'+Num+'</strong></p></div>'
							}else{
								tztyjHtml+=Lhtml+'<p class="text" style="width:150px;" onclick=obj.gridBfyj_Click(\'' + Name + '\',\'' + row.LocID + '\')>'+Name+'<strong class="Numtext" onclick=obj.LocPatients_Click(\'' + Name + '\',\'' + row.LocID + '\')>'+Num+'</strong></p></div>'
							}
							index+=1;
							Rhtml='<div class="common tzty" style="border-right-color:#58EB8E;">'
							Lhtml='<div class="common tzty" style="border-right-color:#58EB8E;">'
						}						
					}
					return  tztyjHtml;
				}
			},
			{ field:"bfqk",title:"七日内暴发<br>报告情况",width:120,align:'center',
				formatter:function(value,row,index){
					var bfqkHtml="";
					var RepID=obj.GetRepID(row.LocID);
					var RepIDData=RepID.split("^");
					for(var i=0;i<RepIDData.length;i++){
						RepID=RepIDData[i];
						if(RepID>0){
							bfqkHtml+='<span class="oblong" onclick=obj.OperReport_Click('+RepID+","+row.LocID+')>'+RepID+'</span>'
						}
					}
					return  bfqkHtml;
						
				}
			}
        ]]
	});
	obj.LocPatients = $HUI.datagrid("#LocPatients",{
		fit: true,
		//title: "预警患者列表",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		url:$URL,
        queryParams:{
        	ClassName:"DHCHAI.IRS.NewCCWaringSrv",
			QueryName:"QryWarnPatList"
		},
		columns:[[
			{field:'RegNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:80},
			{field:'MrNo',title:'病案号',width:100},
			{field:'Sex',title:'性别',width:50},
			{field:'Age',title:'年龄',width:50},
			{field:'WarnLocDesc',title:'预警科室',width:120},
			{field:'WarnBedDesc',title:'预警<br>床位',width:50},
			{field:'zy',title:'摘要',width:50,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.OperZYWinByEpis_Click('+row.EpisodeDr+')>摘要</a>';
				}
			},
			{field:'InfInfo',title:'感染信息',width:150},
			{field:'AdmDate',title:'入院日期',width:95},
			{field:'AdmLoc',title:'当前科室',width:100},
			{field:'AdmWard',title:'当前病区',width:120},
			{field:'AdmBed',title:'当前<br>床位',width:50},
			{field:'sgxx',title:'三管信息',width:80,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.OperSGWinByEpis_Click('+row.EpisodeDr+')>三管信息</a>';
				}
			},
			{field:'DischDate',title:'出院日期',width:95}
		]]
	});

	obj.LocPatientsInfo = $HUI.datagrid("#LocPatientsInfo",{
		fit: true,
		//title: "预警患者列表",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
	    url:$URL,
	    queryParams:{
        	ClassName:"DHCHAI.IRS.NewCCWaringSrv",
			QueryName:"QryWarnPatList"
		},
		columns:[[
			{field:'RegNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:80},
			{field:'MrNo',title:'病案号',width:100},
			{field:'Sex',title:'性别',width:50},
			{field:'Age',title:'年龄',width:50},
			{field:'WarnLocDesc',title:'预警科室',width:120},
			{field:'WarnBedDesc',title:'预警<br>床位',width:50},
			{field:'zy',title:'摘要',width:50,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.OperZYWinByEpis_Click('+row.EpisodeDr+')>摘要</a>';
				}
			},
			{field:'InfInfo',title:'感染信息',width:150},
			{field:'AdmDate',title:'入院日期',width:95},
			{field:'AdmLoc',title:'当前科室',width:100},
			{field:'AdmWard',title:'当前病区',width:120},
			{field:'AdmBed',title:'当前<br>床位',width:50},
			{field:'sgxx',title:'三管信息',width:80,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.OperSGWinByEpis_Click('+row.EpisodeDr+')>三管信息</a>';
				}
			},
			{field:'DischDate',title:'出院日期',width:95}
		]]
	});
	
	obj.GridSgInfo = $HUI.datagrid("#GridSgInfo",{
		fit: true,
		title: "",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		nowrap:true,
		fitColumns: true,
		url:$URL,
        queryParams:{
        	ClassName:"DHCHAI.IRS.ICULogSrv",
			QueryName:"QryICUAdmOeItem"
		},
		columns:[[
			{field:'OeItemType',title:'三管类型',width:100},
			{field:'OeItemDesc',title:'医嘱名称',width:250},
			{field:'StartDt',title:'开嘱时间',width:200},
			{field:'EndDt',title:'停嘱时间',width:200}
		]]
	});
	
	InitCCScreeningWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitCCScreeningWin();
});
