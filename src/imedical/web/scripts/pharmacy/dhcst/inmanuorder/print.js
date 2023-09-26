//

function PintInaManu(InManuOrd){

	var fileName;
	var raqObj = {
	    raqName: "DHCST_InManu_Print_Common.raq",
	    raqParams: {
	        InManu: InManuOrd
	    },
	    isPreview: 1,
	    isPath: ""
	}
	DHCST.RaqPrint(raqObj)
            

}