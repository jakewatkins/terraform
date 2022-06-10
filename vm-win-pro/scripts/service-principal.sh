subscription='a228cfa6-3144-46fa-8784-5ab946c9ad50'
sp= az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${subscription}"