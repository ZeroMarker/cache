$(function () {
	InitReportWin();
});

function InitReportWin(){
	var obj = new Object();   
	obj.ReportID=ReportID;
	if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    }     
	//联系地址
	$('#cboPatAgeDW').combobox({});  //年龄单位
	obj.cboProvince1 = Common_ComboToArea2("cboProvince1","1");            // 省
	obj.RegCity = $HUI.combobox('#cboProvince1', {
		onChange:function(newValue,oldValue){
			$('#cboCity1').combobox('clear');
			$('#cboCounty1').combobox('clear');
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboCity1 = Common_ComboToArea2("cboCity1","cboProvince1");				// 市
		}		
	});
	obj.RegCounty = $HUI.combobox('#cboCity1', {
		onChange:function(newValue,oldValue){
			$('#cboCounty1').combobox('clear');
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboCounty1 = Common_ComboToArea2("cboCounty1","cboCity1");             // 县
		}
	});
	obj.RegVillage = $HUI.combobox('#cboCounty1', {
		onChange:function(newValue,oldValue){
			$('#cboVillage1').combobox('clear');
			$('#txtCUN1').val('');
			obj.cboVillage1 = Common_ComboToArea2("cboVillage1","cboCounty1");         // 乡
		}
	});
	$HUI.combobox('#cboVillage1', {
		onSelect:function(record){
			if (record) {
			    $('#txtCUN1').val('');
				$('#txtAdress1').val($('#cboProvince1').combobox('getText')+$('#cboCity1').combobox('getText')+$('#cboCounty1').combobox('getText')+$('#cboVillage1').combobox('getText'));
			}
		}
	});
	//动态添加村（input）的内容
	$('#txtCUN1').bind('change', function (e) {  //鼠标移动之后事件 
		$('#txtAdress1').val($('#cboProvince1').combobox('getText')+$('#cboCity1').combobox('getText')+$('#cboCounty1').combobox('getText')+$('#cboVillage1').combobox('getText')+$('#txtCUN1').val());
	});
	
	obj.LoadListInfo = function() {	  //加载单选、多选列表          
     	obj.radNYZLSLList = Common_RadioToDic("radNYZLSLList","CRNYZLSL",4);       //种类数量
		obj.radZDYYList = Common_RadioToDic("radZDYYList","CRZDYY",4);             //中毒原因
		obj.radZSPXList = Common_RadioToDic("radZSPXList","CRZSPX",4);             //知识培训
		obj.radSYFSList = Common_RadioToDic("radSYFSList","CRSYFS",4);             //施药方式
		obj.chkWXXWList = Common_CheckboxToDic("chkWXXWList","CRWXXW",4);          //危险行为
		obj.radZDZGList = Common_RadioToDic("radZDZGList","CRZDZG",4);             //转归
		$HUI.radio("[name='radZDZGList']",{
            onChecked:function(e,value){
                var value = $(e.target).attr("label");   //当前选中的值
				if (value=='其他') {		
					$('#txtCRQTZG').removeAttr("disabled");			
				}else{
					$('#txtCRQTZG').val('');
					$('#txtCRQTZG').attr('disabled','disabled');	
				}
            }
        });
	}

	InitReportWinEvent(obj);       
	obj.LoadEvent();       
	return obj;        
}
