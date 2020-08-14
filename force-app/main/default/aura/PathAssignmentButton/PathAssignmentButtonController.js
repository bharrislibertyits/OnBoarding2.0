({
    doInit : function(component, event, helper) {
        var toggleInitial = component.find("initialScreen");
        $A.util.toggleClass(toggleInitial, "toggleOn");
        
        var toggleIntake = component.find("assignPathScreen");
        $A.util.toggleClass(toggleIntake, "toggleOff");
	},
	handleAssignUser : function(component, event, helper) {
        var toggleInitial = component.find("initialScreen");
        $A.util.toggleClass(toggleInitial, "toggleOff");
        $A.util.removeClass(toggleInitial, "toggleOn");
        
        var toggleIntake = component.find("assignPathScreen");
        $A.util.toggleClass(toggleIntake, "toggleOn");
        $A.util.removeClass(toggleIntake, "toggleOff");
	},
})