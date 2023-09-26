Ext.onReady(function() {
    ShowPage();
});

//显示页面
function ShowPage() {
    var tabPanel = new Ext.TabPanel({
        region: 'center',
        renderTo: Ext.getBody(),
        deferredRender: false,
        autoScroll: true,
        margins: '0 4 4 0',
        activeTab: 0,
        width: '100%',
        height: 590,
        items: [{
            id: 'tabBedFeeSet',
            title: "床位附加费用设定",
            closable: false,
            html: ' <iframe scrolling="auto" frameborder="0" width="100%" height="560px" src="DHCPACBedFeeSet.csp"> </iframe>',
            autoScroll: true
        },
        {
            id: 'tabBedTypeFeeSet',
            title: "床位类型附加费用设定",
            closable: false,
            html: ' <iframe id="frameBedTypeFee" scrolling="auto" frameborder="0" width="100%" height="560px" src=""> </iframe>',
            autoScroll: true
        }
        //,
//        {
//            id: 'tabBedFeeTypeSet',
//            title: "床位附加费用类型设定",
//            closable: false,
//            html: ' <iframe scrolling="auto" frameborder="0" width="100%" height="560px" src="DHCPACBedTypeFeeSet.csp"> </iframe>',
//            autoScroll: true
//        }
        ],
        listeners: {'tabchange':test}
        });
}

function test(tabNow, tabClick) {
    if (tabClick.id == "tabBedTypeFeeSet") {
        if (Ext.get('frameBedTypeFee').dom.src.indexOf("DHCPACBedTypeFeeSet.csp") < 0) {
            Ext.get('frameBedTypeFee').dom.src = "DHCPACBedTypeFeeSet.csp";
        }
    }
}