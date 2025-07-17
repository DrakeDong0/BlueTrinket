package structs

type LoginDBObj struct {
	Email    string `json:"email" bson:"Email"`
	Username string `json:"username" bson:"Username"`
}

type UserDBObj struct {
	Sub           string `json:"sub"           bson:"sub"`
	Name          string `json:"name,omitempty"          bson:"name,omitempty"`
	GivenName     string `json:"given_name,omitempty"    bson:"given_name,omitempty"`
	FamilyName    string `json:"family_name,omitempty"   bson:"family_name,omitempty"`
	Nickname      string `json:"nickname,omitempty"      bson:"nickname,omitempty"`
	Email         string `json:"email,omitempty"         bson:"email,omitempty"`
	EmailVerified bool   `json:"email_verified,omitempty" bson:"email_verified,omitempty"`
	Picture       string `json:"picture,omitempty"       bson:"picture,omitempty"`
	Locale        string `json:"locale,omitempty"        bson:"locale,omitempty"`
	UpdatedAt     string `json:"updated_at,omitempty"    bson:"updated_at,omitempty"`
}
