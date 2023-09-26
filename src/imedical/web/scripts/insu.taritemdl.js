/**
 * FileName: insu.taritemdl.js
 * Anchor: ZhaoZW
 * Date: 2020-02-24
 * Description: ҽ��Ŀ¼�������
 */
// ���峣��
var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],	//����ԱID
		CTLOC_ROWID: session['LOGON.CTLOCID'],	//����ID
		WARD_ROWID: session['LOGON.WARDID'],	//����ID
		HOSP_ROWID: session['LOGON.HOSPID']		//Ժ��ID
	},
	CLASSNAME: 'web.InsuTaritemsDLCtl',			//ҵ������߼���
	METHODNAME: {
		IMPORT: 'ImportInsuTarItemByExcel',		//ҽ��Ŀ¼���뷽��
		ADUIT: 'AduitInsuTaritem',				//ҽ��Ŀ¼��˷���
		COMPARE: 'CompareInsuTaritemInfo',  //�ȽϷ���
		ADUITALL: 'AduitInsuTaritemAll',  //��ȫ����ҽ��Ŀ¼����
		GETLASTDOWNDATE: 'QueryLastDownTime' //������һ�����ص�ʱ��
	},
	QUERYNAME: {
		INSU_DICDATA: 'QueryInsuDicDataInfo',	//��ѯҽ���ֵ䷽��
		INSU_TARITEM: 'QueryInsuTaritemInfo',	//��ѯҽ��Ŀ¼����
		DATAVERSION: 'QueryDataVersionInfo'		//��ѯ�������η���
	}
};
//��ں���
$(function (){
	setPageLayout(); //����ҳ�沼��
	setElementEvent();	//����ҳ��Ԫ���¼�	
});
//����ҳ�沼��
function setPageLayout(){
	initDate();//��ʼ������
	initDataList(); //��ʼ�������б�
	initDiffeCateCombo(); //��ʼ�������־������
	initAuditFlagCombo(); //��ʼ����˱�־������
	initINTIMsfxmbmCombo(); //��ʼ��ҽ������������
	initINTIMDicType1Combo(); //��ʼ��Ŀ¼����������(����/����)
	initINTIMDicType2Combo(); //��ʼ��Ŀ¼����������(��ѯ/���)
	initDataVersionCombo(); //��ʼ����������������
}
//����ҳ��Ԫ���¼�
function setElementEvent(){
	initDownloadBtn(); //��ʼ��Ŀ¼���ذ�ť�¼�
	initImportBtn(); //��ʼ��Ŀ¼���밴ť�¼�
	initSearchBtn(); //��ʼ����ѯ��ť�¼�
	initAduitBtn(); //��ʼ����˰�ť�¼�
	initCompareBtn(); //��ʼ���Ƚϰ�ť�¼�
	//initAduitALLBtn(); //��ʼ�����ȫ��ҽ��Ŀ¼�¼�
}
//��ʼ����˰�ť�¼�
function initAduitBtn(){
	$('#aduitBtn').click(function(){
		var rows = $('#DataList').datagrid('getChecked');
		if(rows.length<=0){
			$.messager.popover({msg: '��û��Ҫ�ύ��˵����ݣ�',type:'info',timeout: 1000,showType: 'show'});	
			return;
		}
		$.messager.confirm("ȷ��", "��ȷ��Ҫ�ύ�����?", function (r) {
			if (r) {
				var InitIndex=0;	//��ʼ����
				var ErrMsg="";		//������Ϣ
				var sucNum=0; 		//�ɹ���
				var errNum=0; 		//ʧ����
				SubmitReview(rows,InitIndex,ErrMsg,sucNum,errNum); //�ύ���
			}
		});
	});
}
//��ʼ���Ƚϰ�ť�¼�
function initCompareBtn(){
	$('#compareBtn').click(function(){
		var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			//Ŀ¼����
		var DataVersion= $('#DataVersion').combobox('getText');				//��������
		$.messager.confirm("ȷ��", "��ȷ��Ҫ�Ƚ�û�Ƚϵ���?", function (r) {
			if (r) {
				$m({
					ClassName:PUBLIC_CONSTANT.CLASSNAME,
					MethodName:PUBLIC_CONSTANT.METHODNAME.COMPARE,
					DicType:INTIMDicType,		
					DataVer:DataVersion
					},function(txtData){
						var arr=txtData.split('^');
						$.messager.popover({msg:'�Ƚϳɹ�:'+arr[0]+'�����Ƚ�ʧ�ܣ�'+arr[1]+'����',type:'success',timeout:2000});
		     			loadInsuTaritemInfo();
					}
				);
			}
		});
	});
}
//��ʼ�����ȫ��ҽ��Ŀ¼�¼�
/*
function initAduitALLBtn(){
	$('#compareAllBtn').click(function(){
		var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			//Ŀ¼����
		var DataVersion= $('#DataVersion').combobox('getText');				//��������
		var UserDr=PUBLIC_CONSTANT.SESSION.GUSER_ROWID; //����ԱID
		var InsuType= $('#INTIMsfxmbm').combobox('getValue');
		$.messager.confirm("ȷ��", "��ȷ��Ҫ������е�ҽ��Ŀ¼��?", function (r) {
			if (r) {				
				$m({
					ClassName:PUBLIC_CONSTANT.CLASSNAME,
					MethodName:PUBLIC_CONSTANT.METHODNAME.ADUITALL,
					DicType:INTIMDicType,		
					DataVer:DataVersion,
					UserDr:UserDr,
					InsuType:InsuType
					},function(txtData){
						var arr=txtData.split('^');
						$.messager.popover({msg:'��˳ɹ�:'+arr[0]+'�������ʧ�ܣ�'+arr[1]+'����',type:'success',timeout:2000});
		     			loadInsuTaritemInfo();
					}
				);
				
			}
		});
	});
}
*/
//�ύ���
function SubmitReview(rows,InitIndex,ErrMsg,sucNum,errNum){
	var row=rows[InitIndex];   	//��ǰ��˼�¼
	var length=rows.length;
	var index=$('#DataList').datagrid('getRowIndex', row);	//��ǰ��˼�¼����
	var ID=row.RowID;   			//��ǰ��˼�¼ID
	var UserDr=PUBLIC_CONSTANT.SESSION.GUSER_ROWID //����ԱID
	$cm({
		ClassName:PUBLIC_CONSTANT.CLASSNAME,
		MethodName:PUBLIC_CONSTANT.METHODNAME.ADUIT,
		RowId:ID,
		Index:index,
		UserDr:UserDr
	},function(data){
		if(data.Stauts==0){
			//����������
			$('#DataList').datagrid('updateRow',{
				index:data.Index,
				row:data.Data
			});	
			$('#DataList').datagrid('uncheckRow',data.Index); //ȡ����ѡ
			$("input[type='checkbox']")[Number(data.Index)+1].disabled = true; //��˳ɹ��󣬽��ø�ѡ��
			sucNum=sucNum+1;
		}else{
			var ErrMsg=ErrMsg+";"+data.Info;
			errNum=errNum+1;
		}
		var NextIndex=InitIndex+1;  //��һ��������
		if(NextIndex<length){
			SubmitReview(rows,NextIndex,ErrMsg,sucNum,errNum)	
		}else{
			$.messager.popover({msg:'��˳ɹ�:'+sucNum+'�������ʧ�ܣ�'+errNum+'����',type:'success',timeout:2000});	
		}
	});	
}
//��ʼ����ѯ��ť�¼�
function initSearchBtn(){
	$('#searchBtn').click(function(){
		loadInsuTaritemInfo();
	});
}
//��ʼ��Ŀ¼���ذ�ť�¼�
function initDownloadBtn(){
	/// ҽ��Ŀ¼����
	$('#downloadBtn').click(function(){
		var InsuType= $('#INTIMsfxmbm').combobox('getValue');
		var INTIMDicType= $('#INTIMDicType2').combobox('getValue');
		$m({
		ClassName:PUBLIC_CONSTANT.CLASSNAME,
		MethodName:PUBLIC_CONSTANT.METHODNAME.GETLASTDOWNDATE,
		InsuType:InsuType,
		DicType:INTIMDicType
		},function(data){
			var dateNow=$('#StDate').combobox('getValue');
			var LastDownDate=data.split(" ")[0];
			var diff=dateDiff(dateNow,LastDownDate);
			if(parseInt(diff)<7)
				$.messager.confirm("ȷ��", "���ϴ����ؾ������ֻ��"+diff+"�죬��ȷ��Ҫ����ҽ��Ŀ¼��?", function (r) {
					if (r) {
						downLoadTarItem();
					}
				});
			else
				downLoadTarItem();
		});
	});
}
/// ҽ��Ŀ¼����
function downLoadTarItem(){
	var InsuType=$('#INTIMsfxmbm').combobox('getValue');
	var DicType=$('#INTIMDicType1').combobox('getValue');
	var StDate=$('#StDate').combobox('getValue');
	var UserId=session['LOGON.USERID'];
	var ExpStr=DicType+"^"
	var outStr=InsuBasTarItmDL(InsuType,StDate,UserId,ExpStr);
	if (outStr!="0"){
		alert("ҽ��Ŀ¼���ر���ʧ��!outStr="+outStr);
	}
	else{
		//���ر���ɹ���ˢ��ҳ��
		PageDataRefresh();
	}
}
//��ʼ��Ŀ¼���밴ť�¼�
function initImportBtn(){
	///����˵���������ֵ���Ϣ
	$('#importBtn').click(function(){
		var UserDr=PUBLIC_CONSTANT.SESSION.GUSER_ROWID;		//����ԱID
		var GlobalDataFlg="0";                          	//�Ƿ񱣴浽��ʱglobal�ı�־ 1 ���浽��ʱglobal 0 ���浽����(�����������ͷ�����)
		var ClassName=PUBLIC_CONSTANT.CLASSNAME;    		//���봦������
		var MethodName=PUBLIC_CONSTANT.METHODNAME.IMPORT;   //���봦������
		var ExtStrPam="";                   				//���ò���()
		//ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam, PageDataRefresh);  //���� �����˻ص�����
	});	
}

/// ����˵����������ɺ���ߵ�����ɺ�ˢ��ҳ����ʾ���µ�����
///           1.����������������Ҫ���� 2.��ѯ�����б���Ҫ��ʾ��������
function PageDataRefresh(){
	//1.����������������Ҫ����
	$('#DataVersion').combobox({
		onLoadSuccess: function(){
			$('#DataVersion').combobox('setValue','1'); //��ʼ��������ĳ�ʼֵ
			loadInsuTaritemInfo(); //�ڼ����������γɹ�ʱ���������б������
		}
	});
	$('#DataVersion').combobox('reload');  //��ѯ�����б���Ҫ��ʾ��������
	//initDataVersionCombo();
	//2.��ѯ�����б���Ҫ��ʾ��������
	//loadInsuTaritemInfo();
}

//��ʼ��Ŀ¼����������(����/����)
function initINTIMDicType1Combo(){
	var id='INTIMDicType1';	//������id(����/����)
	var DicType="TariType";  //Ŀ¼�����ֵ����ͱ���Ϊ:TariType
	initCombobox(id,DicType);
}
//��ʼ��Ŀ¼����������(��ѯ/���)
function initINTIMDicType2Combo(){
	var id='INTIMDicType2';	//������id(��ѯ/���)
	var DicType="TariType";  //Ŀ¼�����ֵ����ͱ���Ϊ:TariType
	initCombobox(id,DicType);
}
//��ʼ��ҽ������������
function initINTIMsfxmbmCombo(){
	var id='INTIMsfxmbm';	//������id
	var DicType="DLLType";  //ҽ�������ֵ����ͱ���Ϊ:DLLType
	initCombobox(id,DicType);
}
//��ʼ�������־������
function initDiffeCateCombo(){
	$HUI.combobox("#DifferenceCate",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'ALL',desc:'ȫ������',selected:true},
			{code:'1',desc:'����'},
			{code:'2',desc:'����'},
			{code:'3',desc:'ʧЧ'},
			{code:'0',desc:'�޲���'},
			{code:'99',desc:'δ�Ƚ�'}
		],
		onSelect: function(){
        	loadDataVersionInfo();	//���¼�����������
   		}
	});	
}
//��ʼ����˱�־������
function initAuditFlagCombo(){
	$HUI.combobox("#AuditImportFlag",{
		valueField:'code', 
		textField:'desc',
		panelHeight:"auto",
		data:[
			{code:'ALL',desc:'ȫ������',selected:true},
			{code:'0',desc:'δ���'},
			{code:'1',desc:'����˵���'},
			{code:'2',desc:'��˾ܾ�'}
		],
		onSelect: function(){
        	loadDataVersionInfo();	//���¼�����������
   		}
	});	
}
//��ʼ����������������
function initDataVersionCombo(){
	//var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			
	var INTIMDicType="FYB"	//Ŀ¼����
	var DifferenceCate= $('#DifferenceCate').combobox('getValue');		//�����־
	var AuditImportFlag= $('#AuditImportFlag').combobox('getValue');	//��˱�־
	$HUI.combobox('#DataVersion',{
		valueField:'VerCode', 
		textField:'VerDesc',
		editable:true,
		url:$URL,
		mode:'remote',
    	onBeforeLoad:function(param){
	   		param.ClassName=PUBLIC_CONSTANT.CLASSNAME
	    	param.QueryName=PUBLIC_CONSTANT.QUERYNAME.DATAVERSION
	    	param.ResultSetType="array"
	    	param.DicType=INTIMDicType
	    	param.DiffCate=DifferenceCate
	    	param.AuditFlag=AuditImportFlag
	    },
	    onLoadSuccess:function(){
			$('#DataVersion').combobox('setValue','1');	
		}
	});	
}
//��ʼ�������б�
var count=0; //������
function initDataList(){
	$HUI.datagrid('#DataList',{
		url:$URL,
		fit:true,
		border:false,
		striped:true,
		pagination:true,
		pageSize:20,
		pageList:[20,40,60],
    	columns:[[   
    		{field:'checkbox',checkbox:true},
    		{field:'RowID',title:'RowID',hidden:true},
        	{field:'DataVersion',title:'��������',width:126,align:'center'},    
        	{field:'INTIMxmbm',title:'��Ŀ����',width:126,align:'center'},    
        	{field:'INTIMxmmc',title:'��Ŀ����',width:150,align:'center'},
        	{field:'AuditImportFlag',title:'��˱��',width:100,align:'center',
        		formatter: function(value,row,index){
					if (value=="0"){
						return "δ���";
					}
					if (value=="1"){
						return "��˵���";
					}
					if (value=="2"){
						return "��˾ܾ�";
					}
				},
				styler: function(value,row,index){
					if(value == '1'){
						return 'background-color:#ffee00;color:red;';
					}
				}
        	}, 
        	{field:'ActiveFlg',title:'��Ч��־',width:100,align:'center',
        		formatter: function(value,row,index){
					if (value=="1"){
						return "��Ч";
					}
					if (value=="0"){
						return "��Ч";
					}
				}
        	},    
        	{field:'DifferenceCate',title:'�������',width:100,align:'center',
        		formatter: function(value,row,index){
					if (value=="1"){
						return "����";
					}
					if (value=="2"){
						return "����";
					}
					if (value=="3"){
						return "��Ч��ʶ�仯";
					}
					if (value=="0"){
						return "�޲���";
					}
					if (value=="99"){
						return "δ�Ƚ�";
					}
				}
        	},    
        	{field:'DifferenceCom',title:'��������',width:200,align:'center',showTip:true
        		/*
        		formatter:function(value,rowData){
	        		return "<span title='" + value + "'>" + value + "</span>";
	        		
	        		alert(1)
	        		var abValue = value;
	        		var content = '<a  href="#" title="'+abValue+'" class="hisui-tooltip">' + rowData.INTIMxmmc + '</a>';
        				return content;/*
	        		///abValue=getInsuTarItemDlDesc(value)
        			if (value.length>=22) {
            			//abValue = value.substring(0,13) + "..."	
        				var content = '<a  href="#" title="'+abValue+'" class="hisui-tooltip">' + rowData.INTIMxmmc + '</a>';
        				return content;
        			}else{
        				return value;
        			}
	        	}
	        	*/
        	},
        	{field:'INTIMActiveDate',title:'��Ч����',width:100,align:'center'},
        	{field:'INTIMExpiryDate',title:'ʧЧ����',width:120,align:'center'},
        	{field:'INTIMsfdlbm',title:'�շѴ���',width:100,align:'center'},
        	{field:'INTIMtjdm',title:'ͳ����Ŀ',width:100,align:'center'}, 
        	{field:'INTIMxmlb',title:'��Ŀ���',width:100,align:'center'},
        	{field:'INTIMjx',title:'����',width:100,align:'center'}, 
        	{field:'INTIMpzwh',title:'��׼�ĺ�',width:100,align:'center'},
        	{field:'INTIMbzjg',title:'��׼�۸�',width:100,align:'center'},
        	{field:'INTIMsjjg',title:'ʵ�ʼ۸�',width:100,align:'center'},
        	{field:'INTIMzgxj',title:'����޼�',width:100,align:'center'},
        	{field:'INTIMzfbl1',title:'�Ը�����1',width:100,align:'center'},
        	{field:'INTIMzfbl2',title:'�Ը�����2',width:100,align:'center'},
        	{field:'INTIMzfbl3',title:'�Ը�����3',width:100,align:'center'}, 
        	{field:'INTIMtxbz',title:'�������־',width:100,align:'center'},
        	{field:'INTIMflzb1',title:'����ָ��1',width:100,align:'center'},
        	{field:'INTIMflzb2',title:'����ָ��2',width:100,align:'center'},
        	{field:'INTIMflzb3',title:'����ָ��3',width:100,align:'center'},
        	{field:'INTIMflzb4',title:'����ָ��4',width:100,align:'center'},
        	{field:'INTIMflzb5',title:'����ָ��5',width:100,align:'center'},
        	{field:'INTIMflzb6',title:'����ָ��6',width:100,align:'center'},
        	{field:'INTIMflzb7',title:'����ָ��7',width:100,align:'center'},
        	{field:'INTIMspmc',title:'��Ʒ����',width:100,align:'center'},
        	{field:'INTIMspmcrj',title:'��Ʒ�����ȼ�',width:100,align:'center'},
        	{field:'INTIMljzfbz',title:'�ۼ�������־',width:100,align:'center'}, 
        	{field:'INTIMyyjzjbz',title:'ҽԺ���ӱ�־',width:100,align:'center'},
        	{field:'INTIMyysmbm',title:'ҽԺ��Ŀ����',width:100,align:'center'},
        	{field:'INTIMfplb',title:'��Ʊ���',width:100,align:'center'},
        	{field:'INTIMDicType',title:'Ŀ¼����',width:100,align:'center'},
        	{field:'INTIMUserDR',title:'�����',width:100,align:'center'},
        	{field:'INTIMDate',title:'�������',width:100,align:'center'},
        	{field:'INTIMTime',title:'���ʱ��',width:100,align:'center'},
        	{field:'INTIMADDIP',title:'�޸Ļ���',width:100,align:'center'},
        	{field:'INTIMUnique',title:'ҽ������Ψһ��',width:110,align:'center'}
    	]],
        //������Ϻ󴥷���ȡ���е�checkbox�����ж���Щ��ѡ�򲻿�ѡȡ
        onLoadSuccess:function(data){
            $('#DataList').datagrid('clearSelections');
            if (data.rows.length > 0) {
                for (var i = 0; i < data.rows.length; i++) {
                    //δ�Ƚ���δ��˵����ݲ���ѡ������˵�����Ҳ����ѡ��
                    if (("99"==data.rows[i].DifferenceCate && data.rows[i].AuditImportFlag!="1") || ((data.rows[i].AuditImportFlag == "1"))||("0"==data.rows[i].DifferenceCate)) {
                        $("input[type='checkbox']")[i + 1].disabled = true;
                    }
                }
            }
        },
        //���û����һ��ʱ���������������� rowIndex��������е��������� 0 ��ʼ ,rowData��������ж�Ӧ�ļ�¼
        onClickRow: function(rowIndex, rowData){
            //������Ϻ��ȡ���е�checkbox����,������ѡ�в�����  
            $("input[type='checkbox']").each(function(index, row){
                //�����ǰ�ĸ�ѡ�򲻿�ѡ��������ѡ��
                if (row.disabled == true) {
                    $("#DataList").datagrid('uncheckRow', index - 1);
                }
            });
        },
        //���û�˫��һ��ʱ���������������� rowIndex��������е��������� 0 ��ʼ ,rowData��������ж�Ӧ�ļ�¼
        onDblClickRow : function(rowIndex, rowData) {  
            //������Ϻ��ȡ���е�checkbox����˫����ѡ�в�����  
            $("input[type='checkbox']").each(function(index, row){
                //�����ǰ�ĸ�ѡ�򲻿�ѡ��������ѡ��
                if (row.disabled == true) {
                    $("#DataList").datagrid('uncheckRow', index - 1);
                }
            });
        },
        //���û���ѡȫ����ʱ����
        onCheckAll:function(rows) {  
            var num=0;
            $("input[type='checkbox']").each(function(index, row) {
                if(row.disabled== true){
                    $("#DataList").datagrid('uncheckRow', index - 1); 
                    num++;
                }
            });
            if(num>0){
              $("input[type='checkbox']").each(function(index, row) { 
                      if(count%2==0){
                          if (row.disabled== true){
	                          $("#DataList").datagrid('uncheckRow', index - 1);
                          }
                      }else{
	                  	$("#DataList").datagrid('uncheckRow', index - 1);
                      }
                  }); 
              count++;  
            } 
        }
	});	
}
//����ҽ��Ŀ¼����
function loadInsuTaritemInfo(){
	var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			//Ŀ¼����
	var DataVersion= $('#DataVersion').combobox('getText');				//��������
	var DifferenceCate= $('#DifferenceCate').combobox('getValue');		//�����־
	var AuditImportFlag= $('#AuditImportFlag').combobox('getValue');	//��˱�־
	$('#DataList').datagrid('load',{
		ClassName:PUBLIC_CONSTANT.CLASSNAME,
		QueryName:PUBLIC_CONSTANT.QUERYNAME.INSU_TARITEM,
		DicType:INTIMDicType,		
		DataVer:DataVersion,		
		DiffCate:DifferenceCate,	
		AuditFlag:AuditImportFlag	
	});
}
// ��ѯҽ���ֵ��������(id:������id,DicType:�ֵ����ͱ���)
function initCombobox(id,DicType){
	$HUI.combobox('#'+id,{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	onBeforeLoad:function(param){
	   		param.ClassName=PUBLIC_CONSTANT.CLASSNAME
	    	param.QueryName=PUBLIC_CONSTANT.QUERYNAME.INSU_DICDATA
	   		param.ResultSetType="array"
	 		param.DicType=DicType       
	    },
	    onLoadSuccess:function(){
		    $('#'+id).combobox('setValue','FYB');	
		},
		onSelect: function(){
			if(id=="INTIMDicType2"){
        		loadDataVersionInfo();	//���¼�����������
			}
   		}
	});	
}
//���¼�����������
function loadDataVersionInfo(){
	var INTIMDicType= $('#INTIMDicType2').combobox('getValue');			//Ŀ¼����
	var DifferenceCate= $('#DifferenceCate').combobox('getValue');		//�����־
	var AuditImportFlag= $('#AuditImportFlag').combobox('getValue');	//��˱�־
	$cm({
		ClassName:PUBLIC_CONSTANT.CLASSNAME,
		QueryName:PUBLIC_CONSTANT.QUERYNAME.DATAVERSION,
		ResultSetType:"array",
		DicType:INTIMDicType,
		DiffCate:DifferenceCate,
		AuditFlag:AuditImportFlag
	},function(Data){
		if(Data.length > 0){
			$('#DataVersion').combobox('loadData', Data);
		}
	});
}
//��ʼ������
function initDate(){
	//��ȡ��ǰ����
	var nowDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//���ÿ�ʼ����ֵ
	$('#StDate').datebox('setValue', nowDate);
	//���ý�������ֵ
	$('#EdDate').datebox('setValue', nowDate);
}
//�����������ڵ�������
function dateDiff(firstDate,secondDate){
	var firstDate = new Date(firstDate);
	var secondDate = new Date(secondDate);
	var diff = Math.abs(firstDate.getTime() - secondDate.getTime())
	var result = parseInt(diff / (1000 * 60 * 60 * 24));
	return result
}