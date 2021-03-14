import Cocoa

/*
 View controller for the editor that allows the user to manage user-defined font schemes.
 */
class FontSchemesEditorViewController: NSViewController, NSTableViewDataSource,  NSTableViewDelegate, NSTextFieldDelegate {
    
    // The table listing all user-defined font schemes.
    @IBOutlet weak var editorView: NSTableView!
    
    // Buttons for operations that can be performed on the schemes.
    @IBOutlet weak var btnDelete: NSButton!
    @IBOutlet weak var btnApply: NSButton!
    @IBOutlet weak var btnRename: NSButton!
    
    // A cache that prevents redundant fetch operations when populating the table view.
    private var schemesCache: [FontScheme] = []
    
    // A view that gives the user a visual preview of what each font scheme looks like.
    @IBOutlet weak var previewView: FontSchemePreviewView!
    
    // Used to temporarily store the original name of a font scheme that is being renamed.
    private var oldSchemeName: String = ""
    
    override var nibName: String? {return "FontSchemesEditor"}
    
    override func viewDidAppear() {
        
        // Populate the cache with all user-defined schemes.
        schemesCache = FontSchemes.userDefinedSchemes
        
        // Refresh the table view.
        editorView.reloadData()
        editorView.deselectAll(self)
        
        // Set button states.
        [btnDelete, btnRename, btnApply].forEach({$0.disable()})
        
        // Clear the preview view (no scheme is selected).
        previewView.clear()
    }
    
    // Deletes all font schemes selected in the table view.
    @IBAction func deleteSelectedSchemesAction(_ sender: AnyObject) {
        
        // Descending order
        selectedSchemeNames.forEach({FontSchemes.deleteScheme($0)})
        
        // Update the cache
        schemesCache = FontSchemes.userDefinedSchemes
        
        editorView.reloadData()
        editorView.deselectAll(self)
        
        updateButtonStates()
        updatePreview()
    }
    
    // Returns the names of all font schemes selected in the table view.
    private var selectedSchemeNames: [String] {
        return editorView.selectedRowIndexes.map {schemesCache[$0].name}
    }
    
    // Updates button states depending on how many rows are selected in the table view.
    private func updateButtonStates() {
        
        let selRows: Int = editorView.numberOfSelectedRows
        
        btnDelete.enableIf(selRows > 0)
        btnApply.enableIf(selRows == 1)
        btnRename.enableIf(selRows == 1)
    }
    
    // Renames a single font scheme.
    @IBAction func renameSchemeAction(_ sender: AnyObject) {
        
        let selectedRowView = editorView.rowView(atRow: editorView.selectedRow, makeIfNecessary: true)
        
        if let editedTextField = (selectedRowView?.view(atColumn: 0) as? NSTableCellView)?.textField {
            
            // Shift focus to the text field for the scheme being renamed.
            self.view.window?.makeFirstResponder(editedTextField)
        }
    }
    
    // Applies the selected font scheme to the system.
    @IBAction func applySelectedSchemeAction(_ sender: AnyObject) {
        
        if let scheme = FontSchemes.applyScheme(named: selectedSchemeNames[0]) {
            Messenger.publish(.applyFontScheme, payload: scheme)
        }
    }
    
    // Dismisses the editor dialog.
    @IBAction func doneAction(_ sender: AnyObject) {
        UIUtils.dismissDialog(self.view.window!)
    }
    
    // Updates the visual preview.
    private func updatePreview() {
        
        if editorView.numberOfSelectedRows == 1 {
            
            previewView.scheme = schemesCache[editorView.selectedRow]
            
        } else {
            
            previewView.clear()
        }
    }
    
    // MARK: View delegate and data source functions
    
    // Returns the total number of font schemes
    func numberOfRows(in tableView: NSTableView) -> Int {
        return schemesCache.count
    }
    
    // When the table selection changes, the button states and preview might need to change.
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        updateButtonStates()
        updatePreview()
        
        if editorView.numberOfSelectedRows == 1 {
            oldSchemeName = schemesCache[editorView.selectedRow].name
        }
    }
    
    // Returns a view for a single row
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return GenericTableRowView()
    }
    
    // Returns a view for a single column
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let scheme = schemesCache[row]
        return createTextCell(tableView, tableColumn!, row, scheme.name)
    }
    
    // Creates a cell view containing text
    private func createTextCell(_ tableView: NSTableView, _ column: NSTableColumn, _ row: Int, _ text: String) -> EditorTableCellView? {
        
        if let cell = tableView.makeView(withIdentifier: column.identifier, owner: nil) as? EditorTableCellView {
            
            cell.isSelectedFunction = {(row: Int) -> Bool in
                return self.editorView.selectedRowIndexes.contains(row)
            }
            
            cell.row = row
            
            cell.textField?.stringValue = text
            cell.textField!.delegate = self
            
            return cell
        }
        
        return nil
    }
    
    // MARK: Text field delegate functions
    
    func controlTextDidEndEditing(_ obj: Notification) {
        
        let editedTextField = obj.object as! NSTextField
        
        if let scheme = FontSchemes.userDefinedSchemeByName(oldSchemeName, false) {
            
            let newSchemeName = editedTextField.stringValue
            
            editedTextField.textColor = Colors.playlistSelectedTextColor
            
            // TODO: What if the string is too long ?
            
            // Empty string is invalid, revert to old value
            if StringUtils.isStringEmpty(newSchemeName) {
                
                editedTextField.stringValue = scheme.name
                
            } else if FontSchemes.schemeWithNameExists(newSchemeName) {
                
                // Another scheme with that name exists, can't rename
                editedTextField.stringValue = scheme.name
                
                _ = UIUtils.showAlert(DialogsAndAlerts.genericErrorAlert("Can't rename font scheme", "Another font scheme with that name already exists.", "Please type a unique name."))
                
            } else {
                
                // Update the scheme name
                FontSchemes.renameScheme(scheme.name, newSchemeName)
                
                // Update the cache
                schemesCache = FontSchemes.userDefinedSchemes
            }
        }
    }
}
