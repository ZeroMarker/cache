var Height = document.body.clientHeight-5;
var Width = document.body.clientWidth-3;
var REC = new Array();
var url1="dhcnuremrcomm.csp?EmrCode=DHCNURSXPERSONLIST"; 
var url2="dhcnuremrcomm.csp?EmrCode=DHCNURJXPERSONLIST";
var url3="dhcnuremrcomm.csp?EmrCode=DHCNURGRPERSONLIST";
var DHCNURSXPERSONLISTT101=new Ext.data.JsonStore({data:[],fields:['PersonID','ChestID','PersonName','PersonLocation','PersonClass','Perfessional','PersonSex','PersonDob','PersonAddress','PersonPhone','PersonComeDate','PersonStDate','PersonEndDate','PersonWard','PersonStatus','rw']});
var DHCNURGRPERSONLISTT101=new Ext.data.JsonStore({data:[],fields:['PersonID','ChestID','PersonName','PersonStDate','PersonWorkDate','PersonSex','PersonDob','PersonAddress','PersonPhone','PersonStDate','PersonEndDate','PersonWard','rw']});
var DHCNURJXPERSONLISTT101=new Ext.data.JsonStore({data:[],fields:['PersonID','ChestID','PersonName','PersonLocation','Perfessional','PersonSex','PersonDob','PersonAge','PersonComeDate','PersonWorkDate','PersonWard','PersonStDate','PersonEndDate','PersonAddress','PersonPhone','PersonStatus','rw']});
function BodyLoadHandler()
{
	var gform=Ext.getCmp('gform');
	var tabPanel=CreateTabPanel();
	gform.add(tabPanel);
	gform.doLayout();
}
function CreateTabPanel()
{
	
	var tabPanel=new Ext.TabPanel({
    activeTab: 0,
    height:Height,width:Width,
    items: [{
        id:'p1',title: '实习人员列表',border: false,region: 'center', layout: 'fit',height:Height,width: Width,		
				html:'<iframe id ="Tab1" name="Tab1" style="width:100%; height:100%" src='+url1+' ></iframe>'
    },{
        id:'p2',title: '进修人员列表',border: false,region: 'center', layout: 'fit',height:Height,width: Width,
        html:'<iframe id ="Tab2" name="Tab2" style="width:100%; height:100%" src='+url2+' ></iframe>'
    },{
        id:'p3',title: '工人列表',border: false,region: 'center', layout: 'fit',height:Height,width: Width,
        html:'<iframe id ="Tab2" name="Tab2" style="width:100%; height:100%" src='+url3+' ></iframe>'
    }]
	});
	return tabPanel;
}