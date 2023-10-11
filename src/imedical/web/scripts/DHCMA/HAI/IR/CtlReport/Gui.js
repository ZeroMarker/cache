//页面Gui
var objScreen = new Object();
function InitReportWin(){
	var obj = objScreen;
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 	
    obj.ResultID ='';          //监控项目结果
	obj.MRBRepID = ReportID;   //多重耐药菌报告ID
	obj.InfTypeID ='';
	obj.MRBOutLabType ="";
    obj.LoadDataCss = function() {
		//加载多选列表
		obj.chkContactList  = Common_CheckboxToDic("chkContactList","IRContactList",3);     //隔离措施	
		//obj.chkDropletList  = Common_CheckboxToDic("chkDropletList","IRDropletList",3);   //飞沫隔离	
		obj.chkPlaceList    = Common_CheckboxToDic("chkPlaceList","IRPlaceList",3);   	    //感染病人安置	
		obj.chkUnitList     = Common_CheckboxToDic("chkUnitList","IRUnitList",3);      	    //隔离单元安置 
		obj.chkVisitList    = Common_CheckboxToDic("chkVisitList","IRVisitList",3);         //探视者管理	
		obj.chkEndList 	    = Common_CheckboxToDic("chkEndList","IREndList",3);    		    //终末消毒
		obj.chkDoTS 	    = Common_CheckboxToDic("chkDoTS","IRDoTS",3);    		        //易感因素
		
		//加载单选字典
		//obj.chkInfType 		= Common_RadioToDic("chkInfType","IRInfType",3);   		 	 //感染类型	
		obj.chkInsulatType  = Common_RadioToDic("chkInsulatType","IRInsulatType",3);  		 //隔离方式	
		obj.chkTreatMent    = Common_RadioToDic("chkTreatMent","IRTreatMent",3);    		 //感染病人诊疗		
		obj.chkEnvMent 		= Common_RadioToDic("chkEnvMent","IREnvMent",3);    			 //环境物表处理	
		obj.chkClothMent 	= Common_RadioToDic("chkClothMent","IRClothMent",3);    		 //感染类型
	}
	
	obj.gridApply = $('#gridApply').datagrid({
        fit:true,
        fitColumns:true,
        title:"多耐检出菌",
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:true,
        autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 100,
		pageList : [100,200,500],
	    columns:[[
	        { field:"Bacteria",title:"细菌~标本~送检日期~送检科室",width:230,align:'center',
				formatter:function(value,row,index){
					return row.Bacteria+"~"+row.Specimen+"</br>"+row.ActDate+"~"+row.LocDesc;
				}
			},
			{ field:"InfTypeDesc",title:"感染类型",width:110,align:'center',
				formatter:function(value,row,index){
					var ResultID=row["LabResID"];
					var MRBOutLabType = row["MRBOutLabType"];
					var RowID=row["ResultID"];					 
					if (value!=""){
						return '<a href="#" style="color:#000" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType+ '\',\'' + RowID + '\')">'+value+'</a>';
					}else{
						return '<a href="#" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType+ '\',\'' + RowID + '\')">'+$g('标记')+'</a>';
					}
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.ResultID = rowData.ResultID;
				obj.MRBRepID = rowData.MRBRepID;
				obj.MRBOutLabType = rowData.MRBOutLabType;
				obj.ReportInfo(obj.ResultID,obj.MRBRepID);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果 
			var total = data.total;
			if	(total>0) {	
                if (ReportID) {
					for (r=0;r<total;r++) {
						if (ReportID==data.rows[r].MRBRepID) {
							$(this).datagrid('selectRow',r);
							continue;
						}
					}
				} else if (LabResID) {   //选中选择记录
					for (r=0;r<total;r++) {
						if (LabResID==data.rows[r].LabResID) {
							$(this).datagrid('selectRow',r);
							continue;
						}
					}
				}else {  //默认选中第一条 临床填报
					$(this).datagrid('selectRow',0);
				}
			}
		}
    });

	InitReportWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
