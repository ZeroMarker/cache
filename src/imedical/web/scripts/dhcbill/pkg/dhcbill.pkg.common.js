/*
* 加载套餐字典的数据
* tangzf 2019-08-09
* input: objectId : 元素 Id ; 
*		 DicType : 字典类别 ;
*		 DicCode : 字典代码 ; 
*		 type :  控件类型   'combobox' ; DG：'datagrid' CG：'combogrid' ;可为空 为空时 按combobox加载
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
        $.messager.alert('提示','dhcbill.pkg.common.js中方法:PKGLoadDicData()发生错误:' + error,'info');
    }
}