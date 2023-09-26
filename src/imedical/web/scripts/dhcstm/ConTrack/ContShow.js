/**
 * ��ʾ������function,��Ext.util.Format.InciPicRenderer����
 * @param {String} picSrc:ͼƬԤ��·��
 * @param {String} Inciinfo
 */
function ShowInciContInfo(inci,contno,vendor){
    var userId = session['LOGON.USERID'];
    var groupId = session['LOGON.GROUPID'];
    var locId = session['LOGON.CTLOCID'];
    function GetParam(){
        var gParam=""
        var url = 'dhcstm.ftpcommon.csp?actiontype=GetParamProp&GroupId=' + groupId
                + '&LocId=' + locId + '&UserId=' + userId;
        var response = ExecuteDBSynAccess(url);
        var jsonData = Ext.util.JSON.decode(response);
        if (jsonData.success == 'true') {
            var info = jsonData.info;
            if (info != null || info != '') {
                gParam = info.split('^');
            }
        }
    
        return gParam;
    }
    var gParam=GetParam()
    var ftpsrc =  gParam[5];
    
    var picSrc="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"
    
    var PicUrl = 'dhcstm.druginfomaintainaction.csp?actiontype=GetSynContProductImageInfo';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
                url : PicUrl,
                method : "POST"
                });
            // ָ���в���
    var fields = ["picsrc","imgtype"];
            // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
                root : 'rows',
                totalProperty : "results",
                fields : fields
                });
    // ���ݼ�
    var PicStore = new Ext.data.Store({
                    proxy : proxy,
                    reader : reader
                    });
    PicStore.load({params:{'inci':inci,'contno':contno,'vendor':vendor}});
    var picTpl = new Ext.XTemplate(
        '<tpl for=".">',
            '<div style="padding:5px; height:230px; width:210px; float:left;" class="select_pic" >',
                '<img  class="pic" src="' + ftpsrc + '{picsrc}"style="height:210; width:210;"position: relative;>',
                '<p><font color=blue size="2">{imgtype}</font></p>',
            '</div>',
        '</tpl>'
    );

    var picView = new Ext.DataView({
        store : PicStore,
        tpl : picTpl,
        frame : true,
        singleSelect : true,
        autoScroll:true,
        trackOver : true,
        selectedClass : 'selected-pic',
        overClass : 'over-pic',
        itemSelector : 'div.select_pic',
        emptyText : '��ѡ��Ҫ��ʾ������ͼƬ',
        listeners : {
            'dblclick' : function(v, r) {
            var src = PicStore.getAt(r).get('picsrc')
            var type=PicStore.getAt(r).get('imgtype')
            var allsrc = ftpsrc + src;
            var image = new Image();
            image.src = ftpsrc + src;
            //document.body.appendChild(image); //����ͼƬ
            var OpenWindow=window.open(allsrc,"",'height='+(image.height+30)+',width='+(image.width+30)+',resizable=yes,scrollbars=yes,status =yes')
            }
        }
    });
    
    var detailPanel = new Ext.Panel({
        region:'center',
        items : picView,
        //width : 460,
        autoScroll : true
    });
    
 
    var InciInfoWin = new Ext.Window({
        title : '��ͬͼƬ',
        width:560,
        height: 500,
        maximizable:true,
        modal : true,
        layout : 'border',
        items : [detailPanel]
    });
    InciInfoWin.show();
}