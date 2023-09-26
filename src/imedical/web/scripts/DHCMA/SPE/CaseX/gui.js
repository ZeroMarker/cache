//页面Gui
function InitCaseXWin(){
	var obj = new Object();
	$.parser.parse();
	
	//筛查项目
	Spe_CheckboxToDic("chkScreenItems",1)
	
	//医院
	obj.cboHospital=Common_ComboToSSHosp("cboHospital",SSHospCode,"SPE");
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["CTHospID"];
			obj.cboRepLoc=Common_ComboToLoc("cboLoc","E","","I",HospID);//E|W
			
			obj.cboRepWard=Common_ComboToLoc("cboWard","W","","I",HospID);
	    }
    });
    $HUI.combobox('#cboLoc',{
	    onSelect:function(rows){
		    var HospID=$("#cboHospital").combobox('getValue');
		    var LoCID=rows["LocRowId"];
			obj.cboRepWard=Common_ComboToLoc("cboWard","W",LoCID,"I",HospID);
	    },
	    onChange:function(rows){
		    var HospID=$("#cboHospital").combobox('getValue');
		    var LoCID=$("#cboLoc").combobox('getValue');
		    if(LoCID==""){
			    obj.cboRepWard=Common_ComboToLoc("cboWard","W","","I",HospID);
		    }
	    }
    });

	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	
	obj.gridCaseX=$HUI.datagrid("#gridCaseX",{
		fit:true,
		title:"监控数据显示",
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, 
		loadMsg:'数据加载中...',
		pageSize: 100,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'chkFlag',checkbox:'true',align:'center',width:'30',auto:false},
			{field:'CaseXID',title:'标记',width:60,align:'center',
				formatter: function(value,row,index){
					if (value=="") return "";
					var tSpePatInfo = row["SpePatInfo"];
					var arrSpePatInfo = tSpePatInfo.split(CHR_1);
					var strRet = '';
					for (var indSP = 0; indSP < arrSpePatInfo.length; indSP++){
						var tPatInfo = arrSpePatInfo[indSP];
						if (!tPatInfo) continue;
						var arryFields = tPatInfo.split('^');
						strRet += "<a href='#' onmousedown='return objScreen.DisplaySpeMarkWin(" + arryFields[0] + ");'>"
						strRet += "<img src='../scripts/DHCMA/img/spe/" + arryFields[4] + "' width='16' height='16' alt='" + arryFields[3] + "-" + arryFields[2]+"'  title='" + arryFields[3] + "-" + arryFields[2]+"'/>"
						strRet += "</a>";
					}
					return strRet;
				}
			},
			{field:'RegNo',title:'登记号',width:'100',sortable:true},
			{field:'PatientName',title:'患者姓名',width:'100'},
			{field:'Sex',title:'性别',width:'80'},
			{field:'Age',title:'年龄',width:'80'},
			{field:'ScreeningDesc',title:'筛查项目', width:'180', align:'left'},
			{field:'StatusDesc',title:'状态',width:'80',align:'center'},
			{field:'VisitStatus',title:'排除原因',width:'180'},
			{field:'Opinion',title:'特殊患者状态',width:'120'},
			{field:'PatTypeDesc',title:'类型',width:'80',align:'center'},
			{field:'LocDesc',title:'科室',width:'120'},
			{field:'WardDesc',title:'病区',width:'140'},
			{field:'Bed',title:'床号',width:'80'},
			{field:'AdmitDate',title:'入院日期',width:'120'},
			{field:'DischDate',title:'出院日期',width:'120'},
			{field:'PatientStatus',title:'就诊状态',width:'80',sortable:true},
			{field:'DoctorName',title:'主管医生',width:'120'},
			{field:'EpisodeID',title:'就诊号',width:'80'}
		]]
	});
	

	//重组公共方法 特殊患者筛查项目列表
	//多选字典 显示 obj.StatusList = Spe_CheckboxToDic("chkScreenItems","SPEStatus","");
	function Spe_CheckboxToDic() {
		var ItemCode = arguments[0];
		var columns = arguments[1]? arguments[1] : 1;
		
		var strDicList =$cm({
			ClassName:"DHCMed.SPEService.Screening",
			QueryName:"QueryScreening",
			aIsActive:1
		},false);
		var len =strDicList.total;	
		var dicList=strDicList["rows"]
		var count = parseInt(len/columns)+1;
		var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
		
		var listHtml=""
		for (var index =0; index< count; index++) {
			var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
			listHtml +="<div>"; 
			for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
				var ID = dicList[dicIndex].ID
				var Code=dicList[dicIndex].Code
				var Desc=dicList[dicIndex].Desc
				
				listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+ID+" type='checkbox' class='hisui-checkbox' "+(0==1? "checked='true'":"")+" label="+Desc+"  name="+ItemCode+"  value="+Code+"></div>";  
			} 
			listHtml +="</div>"
		}
		$('#'+ItemCode).html(listHtml); 
		$.parser.parse('#'+ItemCode);  //解析checkbox	
	}

	InitCaseXWinEvent(obj);
	obj.LoadEvent(arguments)
	return obj;
}



