/** 
 * ģ��: 	 ��Һ����ͳ�Ʊ���
 * ��д����: 2018-03-27
 * ��д��:   yunhaibao
 */
var PIVAREPORT={
	tabGzl:"DHCST.PIVA.REPORT.WORKSTAT.csp", 		  // ��Һ������ͳ��
	tabPivaQuantity:"DHCST.PIVA.REPORT.QUANTITY.csp", // ��Һ��ͳ��
	tabPivaOeStat:"DHCST.PIVA.REPORT.OESTAT.csp",     // ����ͳ��
	tabRefSuccess:"DHCST.PIVA.REPORT.REFSUCCESS.csp", // ��Ԥҽ��ͳ��
	tabPivaStat:"DHCST.PIVA.REPORT.PIVASTAT.csp"  	  // ��Һ״̬һ��
}
var SessionLoc=session['LOGON.CTLOCID'];
var SessionUser=session['LOGON.USERID'];
$(function(){
	InitDict();
	$('#tabsCalcu').tabs({   
		border:false,   
		onSelect:function(title){  

		}   
  	});	
	$('#btnFind').on("click",Query);
  	$("#tabWardBat").append('<iframe id="'+"tabWardBatFrame"+'"></iframe>');
	$("#tabWardBatFrame").attr("src",PIVAREPORT['tabGzl'])
	//InitPivasSettings();
});
function InitDict(){
	// ��Һ����
	PIVAS.ComboBox.Init(
		{Id:'cmbPivaLoc',Type:'PivaLoc'},
		{
			editable:false,
			onLoadSuccess: function(){   
		    },
		    onSelect:function(data){

			},
			width:214
		}
	);
	// ������
	PIVAS.ComboBox.Init({Id:'cmbLocGrp',Type:'LocGrp'},{width:214});
	// ����
	PIVAS.ComboBox.Init({Id:'cmbWard',Type:'Ward'},{width:214});
	// ҽ�����ȼ�
	PIVAS.ComboBox.Init({Id:'cmbPriority',Type:'Priority'},{width:214});
	// ��������
	PIVAS.ComboBox.Init({Id:'cmbWorkType',Type:'PIVAWorkType'},{width:214});
	// ҩƷ
	PIVAS.ComboGrid.Init({Id:'cmgIncItm',Type:'IncItm'},{width:214});
	// ���
	PIVAS.ComboBox.Init({Id:'cmbPack',Type:'YesOrNo'},{width:214});
	// ����
	PIVAS.BatchNoCheckList({Id:"DivBatNo",LocId:SessionLoc,Check:true,Pack:false});
	// ��Һ״̬
	PIVAS.ComboBox.Init({Id:'cmbPivaStat',Type:'PIVAState'},{
		editable:false,
		onLoadSuccess: function(){
		//	$(this).combobox('showPanel');
		},
		width:214
	});
}

/// ��ѯ
function Query(){
	alert(1)
}
