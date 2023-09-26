/*
* �����ײ��ֵ������
* tangzf 2019-08-09
* input: objectId : Ԫ�� Id ; 
*		 DicType : �ֵ���� ;
*		 DicCode : �ֵ���� ; 
*		 type :  �ؼ�����   'combobox' ; DG��'datagrid' CG��'combogrid' ;��Ϊ�� Ϊ��ʱ ��combobox����
* output: 			
*/
function PKGLoadDicData(objectId, DicType, DicCode, type) {
    try {
        var url = $URL + "?ClassName=BILL.PKG.BL.Dictionaries&QueryName=QueryDic&ResultSetType=Array&Type=" + DicType+'&Code='+DicCode ;
        switch (type) {
            case 'DG':
                $('#' + objectId).datagrid('options').url=url;
                $('#' + objectId).datagrid('load');
                break;
            case 'CG':
                $('#' + objectId).combobox('clear');
                $('#' + objectId).combogrid('grid').datagrid('options').url=url;
                $('#' + objectId).combogrid('grid').datagrid('reload') ;
                break;
            default:
                $HUI.combobox('#'+objectId,{
					valueField:'Code',
					textField:'Desc',
					url:$URL,
					defaultFilter:4,
					onBeforeLoad:function(param){
						param.ClassName='BILL.PKG.BL.Dictionaries';
						param.QueryName='QueryDic';
						param.ResultSetType='Array';
						param.DictType=DicType;
						param.DicCode=DicCode;
						param.HospDr=PUBLIC_CONSTANT.SESSION.HOSPID;
					}
				})
                break;
        }
    } catch (error) {
        $.messager.alert('��ʾ','dhcbill.pkg.common.js�з���:PKGLoadDicData()��������:' + error,'info');
    }
}