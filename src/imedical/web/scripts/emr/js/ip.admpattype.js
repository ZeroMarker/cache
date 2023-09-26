
//��������
var _diseaseCount=0;
//��ʼ����־
var _flagInit = true;

$(function(){
	
	//�������ȡ���ֹ���ģ��
	InitDiseaseCom(locId);
	
	$('#removeData').bind('click', function () {
        removeData(episodeId,userId);
    });
	
});

//���ز�����������
function InitDiseaseCom(locId){
	
	
	$("#selDiseaseSpecies").combogrid({  
		panelWidth:278,
		panelHeight:200,
		url: "../EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.BLUserTemplate&Method=getDiseaseByDiagnos&p1="+DiagnosInfo+"&p2="+locId,		
	    idField:'Code',  
	    textField:'Name',
	    fitColumns: true,
	    columns:[[  
	        {field:'Code',title:'����',width:130,sortable:true},  
	        {field:'Name',title:'����',width:130,sortable:true}  
		 ]],
		 keyHandler:{
			up: function() {
			    //ȡ��ѡ����
               var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //ȡ��ѡ���е�rowIndex
                    var index = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRowIndex', selected);
                    //�����ƶ�����һ��Ϊֹ
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
              //ȡ��ѡ����
                //ȡ��ѡ����
               var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //ȡ��ѡ���е�rowIndex
                    var index = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRowIndex', selected);
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    //�����ƶ������һ��Ϊֹ
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
				//��enter�� 
				//�ı��������Ϊѡ���еĵ��ֶ�����
                var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');  
			    if (selected) 
			    { 
					$('#selDiseaseSpecies').combogrid("options").value = selected.Name;
			    }
                 //ѡ�к������������ʧ
                $('#selDiseaseSpecies').combogrid('hidePanel');
				$("#selDiseaseSpecies").focus();
            }, 
			query: function(q) {
				if(q==""){
					$("#icdlist").combogrid('clear');	
				}
				var selLocId="";
				
 	            //��̬����
	            $('#selDiseaseSpecies').combogrid("grid").datagrid("reload", {'p1':"",'p2':locId,'p3':q});
	            $('#selDiseaseSpecies').combogrid("setValue", q);  
	        }
	    },
	    onSelect:function (index,d){
		    
		    var selDiseaseSpecies = d.Code;
			//ѡ�к󣬴洢��������
			$("#spDiseaseName")[0].innerText = d.Name;
			saveAdmPatType(episodeId,d.Code,userId)
			
			
		 },
	     onShowPanel:function(){
			if($('#selDiseaseSpecies').combogrid('grid').datagrid('getRows').length==0){
				$('#selDiseaseSpecies').combogrid("grid").datagrid("reload", {'p1':"",'p2':locId ,'p3':""});	
			}
		},
		 onLoadSuccess:function(){
			
			 //��ʼ��ѡ�л��߱��ξ���Ĳ���
			var diseaseCode = ""
			diseaseCode = getPatDisease(episodeId);
			
			if (diseaseCode!="" && _flagInit)
			{
				objDisease = eval("["+diseaseCode+"]")[0];
				$("#selDiseaseSpecies").combogrid("setValue",objDisease.Name);
				$("#spDiseaseName")[0].innerText = (objDisease.Name==undefined||objDisease.Name=="")?"δ��������":objDisease.Name;
	
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
					//��ϲ�Ϊ��  ��һ��ʱ������Ϲ����Ĳ���ѡ�е�һ��
					var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
					_diseaseCount=rows.length;
					if(_diseaseCount>0){
						$('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);	
					}
					
					
				}else if(DiagnosInfo=="" && _flagInit){
					//���Ϊ�� ��һ�μ���ʱĬ�ϼ��ؿ��Ҳ���  ��ѡ��
					$('#selDiseaseSpecies').combogrid("grid").datagrid("reload", {'p1':"",'p2':locId,'p3':""});
				}
			}
			_flagInit=false;
		}
	});
}



//�رմ���
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}


//��ȡ���߾����б�
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

//��ȡ���߾����б�
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
				$("#spDiseaseName")[0].innerText = "δ��������";
				$('#selDiseaseSpecies').combogrid('setValue','');
			}
		},
		error : function(d) { 
			alert("ClearAdmPatType error");
		}
	});	
	
	return;
}
