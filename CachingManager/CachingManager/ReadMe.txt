/*
 * This is simple example of fast caching of data.
 * If you do not want to use CoreData or any 3rd parties and just want to have
 *  a simple solution to save something in local storage - you may use this approach.
 
 * What you can save?
 * Any data structure that conforms to Codable protocol, i.e. almost everything.
 
 * The solution hase some useful things for optimisation:
 *      - Allows to set data lifetime (if data is not actual already - this will simply erased).
 *      - Allows to erase storage (to clear cache from app settings of after application update).
 *      - Uses dedicated serial thread to syncoronize all actions and avoid issues like race condition.
 *      - On app starting - fetches all saved keys (to avoid redundant moves if data was not saved yet).
 *      - In case object data was loaded - saves locally to avoid unnecessary loading from disk next time.
 *
 */
