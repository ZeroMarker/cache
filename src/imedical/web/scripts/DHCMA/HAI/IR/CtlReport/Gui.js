//ҳ��Gui
var objScreen = new Object();
function InitReportWin(){
	var obj = objScreen;
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 	
    obj.ResultID ='';          //�����Ŀ���
	obj.MRBRepID = ReportID;   //������ҩ������ID
	obj.InfTypeID ='';
	obj.MRBOutLabType ="";
    obj.LoadDataCss = function() {
		//���ض�ѡ�б�
		obj.chkContactList  = Common_CheckboxToDic("chkContactList","IRContactList",3);     //�����ʩ	
		//obj.chkDropletList  = Common_CheckboxToDic("chkDropletList","IRDropletList",3);   //��ĭ����	
		obj.chkPlaceList    = Common_CheckboxToDic("chkPlaceList","IRPlaceList",3);   	    //��Ⱦ���˰���	
		obj.chkUnitList     = Common_CheckboxToDic("chkUnitList","IRUnitList",3);      	    //���뵥Ԫ���� 
		obj.chkVisitList    = Common_CheckboxToDic("chkVisitList","IRVisitList",3);         //̽���߹���	
		obj.chkEndList 	    = Common_CheckboxToDic("chkEndList","IREndList",3);    		    //��ĩ����
		obj.chkDoTS 	    = Common_CheckboxToDic("chkDoTS","IRDoTS",3);    		        //�׸�����
		
		//���ص�ѡ�ֵ�
		//obj.chkInfType 		= Common_RadioToDic("chkInfType","IRInfType",3);   		 	 //��Ⱦ����	
		obj.chkInsulatType  = Common_RadioToDic("chkInsulatType","IRInsulatType",3);  		 //���뷽ʽ	
		obj.chkTreatMent    = Common_RadioToDic("chkTreatMent","IRTreatMent",3);    		 //��Ⱦ��������		
		obj.chkEnvMent 		= Common_RadioToDic("chkEnvMent","IREnvMent",3);    			 //���������	
		obj.chkClothMent 	= Common_RadioToDic("chkClothMent","IRClothMent",3);    		 //��Ⱦ����
	}
	
	obj.gridApply = $('#gridApply').datagrid({
        fit:true,
        fitColumns:true,
        title:"���ͼ����",
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:true,
        singleSelect:true,
        autoRowHeight: true, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		loading:true,
		pageSize: 100,
		pageList : [100,200,500],
	    columns:[[
	        { field:"Bacteria",title:"ϸ��~�걾~�ͼ�����~�ͼ����",width:230,align:'center',
				formatter:function(value,row,index){
					return row.Bacteria+"~"+row.Specimen+"</br>"+row.ActDate+"~"+row.LocDesc;
				}
			},
			{ field:"InfTypeDesc",title:"��Ⱦ����",width:110,align:'center',
				formatter:function(value,row,index){
					var ResultID=row["LabResID"];
					var MRBOutLabType = row["MRBOutLabType"];
					var RowID=row["ResultID"];					 
					if (value!=""){
						return '<a href="#" style="color:#000" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType+ '\',\'' + RowID + '\')">'+value+'</a>';
					}else{
						return '<a href="#" onclick="objScreen.MenuEdit(\'' +index + '\',\'' + ResultID+ '\',\'' + MRBOutLabType+ '\',\'' + RowID + '\')">'+$g('���')+'</a>';
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
			dispalyEasyUILoad(); //����Ч�� 
			var total = data.total;
			if	(total>0) {	
                if (ReportID) {
					for (r=0;r<total;r++) {
						if (ReportID==data.rows[r].MRBRepID) {
							$(this).datagrid('selectRow',r);
							continue;
						}
					}
				} else if (LabResID) {   //ѡ��ѡ���¼
					for (r=0;r<total;r++) {
						if (LabResID==data.rows[r].LabResID) {
							$(this).datagrid('selectRow',r);
							continue;
						}
					}
				}else {  //Ĭ��ѡ�е�һ�� �ٴ��
					$(this).datagrid('selectRow',0);
				}
			}
		}
    });

	InitReportWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
