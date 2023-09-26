
//病种数量
var _diseaseCount=0;
//初始化标志
var _flagInit = true;

$(function(){
	
	//根据诊断取病种关联模板
	InitDiseaseCom(locId);
	
	$('#removeData').bind('click', function () {
        removeData(episodeId,userId);
    });
	
});

//加载病种下拉框病种
function InitDiseaseCom(locId){
	
	
	$("#selDiseaseSpecies").combogrid({  
		panelWidth:278,
		panelHeight:200,
		url: "../EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.BLUserTemplate&Method=getDiseaseByDiagnos&p1="+DiagnosInfo+"&p2="+locId,		
	    idField:'Code',  
	    textField:'Name',
	    fitColumns: true,
	    columns:[[  
	        {field:'Code',title:'编码',width:130,sortable:true},  
	        {field:'Name',title:'病种',width:130,sortable:true}  
		 ]],
		 keyHandler:{
			up: function() {
			    //取得选中行
               var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) 
                    {
                        $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } 
                else 
                {
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }	
			},
			down: function() {
              //取得选中行
                //取得选中行
               var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRowIndex', selected);
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    //向下移动到最后一行为止
                    if (index < rows.length-1) 
                    {
                        $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } 
                else 
                {
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);
                }			
			},
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () {
				//按enter键 
				//文本框的内容为选中行的的字段内容
                var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');  
			    if (selected) 
			    { 
					$('#selDiseaseSpecies').combogrid("options").value = selected.Name;
			    }
                 //选中后让下拉表格消失
                $('#selDiseaseSpecies').combogrid('hidePanel');
				$("#selDiseaseSpecies").focus();
            }, 
			query: function(q) {
				if(q==""){
					$("#icdlist").combogrid('clear');	
				}
				var selLocId="";
				
 	            //动态搜索
	            $('#selDiseaseSpecies').combogrid("grid").datagrid("reload", {'p1':"",'p2':locId,'p3':q});
	            $('#selDiseaseSpecies').combogrid("setValue", q);  
	        }
	    },
	    onSelect:function (index,d){
		    
		    var selDiseaseSpecies = d.Code;
			//选中后，存储患者类型
			$("#spDiseaseName")[0].innerText = d.Name;
			saveAdmPatType(episodeId,d.Code,userId)
			
			
		 },
	     onShowPanel:function(){
			if($('#selDiseaseSpecies').combogrid('grid').datagrid('getRows').length==0){
				$('#selDiseaseSpecies').combogrid("grid").datagrid("reload", {'p1':"",'p2':locId ,'p3':""});	
			}
		},
		 onLoadSuccess:function(){
			
			 //初始，选中患者本次就诊的病种
			var diseaseCode = ""
			diseaseCode = getPatDisease(episodeId);
			
			if (diseaseCode!="" && _flagInit)
			{
				objDisease = eval("["+diseaseCode+"]")[0];
				$("#selDiseaseSpecies").combogrid("setValue",objDisease.Name);
				$("#spDiseaseName")[0].innerText = (objDisease.Name==undefined||objDisease.Name=="")?"未关联病种":objDisease.Name;
	
				var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
				_diseaseCount=rows.length;	
				
				if(_diseaseCount>0){
					
					for (i=0;i<_diseaseCount;i++)
					{
						row = rows[i]
						if (row.Code == objDisease.Code)
						{
							$('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', i);	
						}
					}
				}
					
			}
			else
			{
				if(DiagnosInfo!="" &&_flagInit){
					//诊断不为空  第一次时根据诊断关联的病种选中第一条
					var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
					_diseaseCount=rows.length;
					if(_diseaseCount>0){
						$('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);	
					}
					
					
				}else if(DiagnosInfo=="" && _flagInit){
					//诊断为空 第一次加载时默认加载科室病种  不选中
					$('#selDiseaseSpecies').combogrid("grid").datagrid("reload", {'p1':"",'p2':locId,'p3':""});
				}
			}
			_flagInit=false;
		}
	});
}



//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}


//获取患者就诊列表
function getPatDisease(episodeId)
{
	var result = "0";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLAdmPatType",
			"Method":"GetAdmPatType",
			"p1":episodeId
		},
		success: function(d) {
			result = d;
		},
		error : function(d) { 
			alert("GetAdmPatType error");
		}
	});	
	return result;
}

//获取患者就诊列表
function saveAdmPatType(episodeId,diseaseCode,userId)
{
	
	var result = "0";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLAdmPatType",
			"Method":"SaveAdmPatType",
			"p1":episodeId,
			"p2":diseaseCode,
			"p3":userId
		},
		success: function(d) {
			result = d;
		},
		error : function(d) { 
			alert("saveAdmPatType error");
		}
	});	
	
	return;
}

function removeData(episodeId,userId)
{
	var result = "0";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLAdmPatType",
			"Method":"ClearAdmPatType",
			"p1":episodeId,
			"p2":userId
		},
		success: function(d) {
			if(d == 1)
			{
				$("#spDiseaseName")[0].innerText = "未关联病种";
				$('#selDiseaseSpecies').combogrid('setValue','');
			}
		},
		error : function(d) { 
			alert("ClearAdmPatType error");
		}
	});	
	
	return;
}
