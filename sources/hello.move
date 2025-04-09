module hello::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};
    use std::string::String;
    use std::vector;
    use sui::event;
    use std::option;
    use sui::coin::{Self, TreasuryCap, Coin,CoinMetadata};
    use std::ascii;

    public struct Sui_frenTresuaryCapHolder has key{
        id: UID,
        treasury_cap: TreasuryCap<SUI_FREN>,
        metadata: CoinMetadata<SUI_FREN>
    }

    // public struct SuiFren has key {
    //     id: UID,
    //     generation: u64,
    //     birthdate: u64,
    //     attributes: vector<String>,
    // }

    // public struct CANDY has drop {}

    // ✅ THIS is the required one-time witness struct
    public struct SUI_FREN has drop {}

    // ✅ init must NOT be public
    fun init(otw: SUI_FREN, ctx: &mut TxContext): () {
        let (treasury_cap, metadata) = coin::create_currency(
            otw,
            9,
            b"SUI_FREN",
            b"SuiFren Candy",
            b"Candies to level up SuiFren",
            option::none(),
            ctx
        );
        // transfer::public_freeze_object(metadata);
        let treasury_cap_holder = Sui_frenTresuaryCapHolder {
            id: object::new(ctx),
            treasury_cap: treasury_cap,
            metadata: metadata
        }; // why we do this cause cause treasuty cap has a store key ability so it can be stored in other structs and objects! So the solution here would be to wrap it in a shared object that anyone can access and provide as an argument to the mint function:
        // transfer::public_transfer(metadata, tx_context::sender(ctx))
        // another thing here is like we metioned that id should be unique for every new instance of Sui_frenTresuaryCapHolder, cause every new user come here and mint there own token so every time new object is created and every new onject shpould have a unique id. 

       
         transfer::share_object(treasury_cap_holder);

        // transfer::public_transfer(treasury_cap, sender(ctx));
    }

    fun mint(treasury_cap: &mut Sui_frenTresuaryCapHolder, amount: u64 , ctx: &mut TxContext){

        // coin::mint_and_transfer(treasury_cap, amount,  tx_context::sender(ctx), ctx) // this is for only owner can able to mint and get the natve token 
        let trasuray_cap = &mut treasury_cap.treasury_cap;
        coin::mint_and_transfer(trasuray_cap, amount, tx_context::sender(ctx), ctx)
    }

    entry fun Transfer_half_amount(from: &mut Coin<SUI_FREN> ,amount: u64, to: &mut Coin<SUI_FREN>, ctx: &mut TxContext) {
        //  let half_value = coin::balance(coin)(from) / 2; 
        let half_amount = coin::take(coin::balance_mut(from), amount, ctx);
        coin::put(coin::balance_mut(to), half_amount);

       }

//     public struct Balance<T> has store {
//         value: u64,
//     }

//     public fun join<T>(self: &mut Balance<SUI_FREN>, balance: Balance<SUI_FREN>): u64 {
//     let Balance { value } = balance;
//     self.value = self.value + value;
//     self.value
// }

//     public fun split<SUI_FREN>(self: &mut Balance<SUI_FREN>, value: u64): Balance<SUI_FREN> {
//     assert!(self.value >= value, 0);
//     self.value = self.value - value; // extract the value from the original balance 
//     Balance { value } // return the new balance
//     }
//     public fun get_balance<SUI_FREN>(self: &Balance<SUI_FREN>): u64 {
//         self.value
//     }

// i want to burn the coin with Sui_frenTresuaryCapHolder

    // burn coin with Sui_frenTresuaryCapHolder
    public fun burn(treasury_cap: &mut Sui_frenTresuaryCapHolder, coin:Coin<SUI_FREN>) {
        let treasury_cap = &mut treasury_cap.treasury_cap;
        coin::burn(treasury_cap, coin);
    }

 // burn the specific amount of coin with Sui_frenTresuaryCapHolder
entry fun burn_coin_with_amount(
    treasury_cap: &mut Sui_frenTresuaryCapHolder,
    coin: &mut Coin<SUI_FREN>,
    amount: u64,
    ctx: &mut TxContext
) {
    let coins_to_burn = coin::take(coin::balance_mut(coin), amount, ctx);
    let cap = &mut treasury_cap.treasury_cap;
    coin::burn(cap, coins_to_burn); 
}

    fun update_name(holder: &mut Sui_frenTresuaryCapHolder, new_name: String){
        let metadata = &mut holder.metadata;
        let trasury_cap = &holder.treasury_cap;
        coin::update_name(trasury_cap, metadata, new_name);
    }

    fun update_symbol(holder: &mut Sui_frenTresuaryCapHolder, new_symbol: ascii::String ){
        let metadata = &mut holder.metadata;
        let trasury_cap = &holder.treasury_cap;
        coin::update_symbol(trasury_cap, metadata, new_symbol);
    }

    fun update_description(holder: &mut Sui_frenTresuaryCapHolder, new_description: String){
        let metadata = &mut holder.metadata;
        let trasury_cap = &holder.treasury_cap;
        coin::update_description(trasury_cap, metadata, new_description);
    }

}

